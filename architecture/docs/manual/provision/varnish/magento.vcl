# VCL version 5.0 is not supported so it should be 4.0 even though actually used Varnish version is 5
vcl 4.0;

import std;
# The minimal Varnish version is 5.0
# For SSL offloading, pass the following header in your proxy server or load balancer: 'X-Forwarded-Proto: https'

backend default {
    .host               = "127.0.0.1";
    .port               = "<apache_port>";
    .connect_timeout    = 3.5s;
    .first_byte_timeout = 60s;
    .probe = {
        # SMILE - use magento healthcheck variable to be consistent into VCL
        .url = "/health_check.php";
        .timeout = 2s;
        .interval = 5s;
        .window = 10;
        .threshold = 5;
    }
}

acl purge {
    "localhost";
    "myfront1";
    "myfront2";
}

acl admin {
    "localhost";
    "myfront1";
    "myfront2";
}

# Add here smile IP, client IP, and IP from payment provider callback
acl client {
}

sub vcl_recv {
    set req.backend_hint = magento;

    # Add protection on BO only
    if (req.url ~ "/<project_bo_url>") {
        if (!(std.ip(regsub(req.http.X-Forwarded-For, "[, ].*$", ""), client.ip) ~ client )) {
            return(synth(401, "Forbidden"));
        }
    }

    # Normalize the query arguments
    set req.url = std.querysort(req.url);

    if (req.method == "PURGE") {
        if (client.ip !~ purge) {
            return (synth(405, "Method not allowed"));
        }
        # To use the X-Pool header for purging varnish during automated deployments, make sure the X-Pool header
        # has been added to the response in your backend server config. This is used, for example, by the
        # capistrano-magento2 gem for purging old content from varnish during it's deploy routine.
        if (!req.http.X-Magento-Tags-Pattern && !req.http.X-Pool) {
            return (synth(400, "X-Magento-Tags-Pattern or X-Pool header required"));
        }
        if (req.http.X-Magento-Tags-Pattern) {
          ban("obj.http.X-Magento-Tags ~ " + req.http.X-Magento-Tags-Pattern);
        }
        if (req.http.X-Pool) {
          ban("obj.http.X-Pool ~ " + req.http.X-Pool);
        }
        return (synth(200, "Purged"));
    }

    if (req.method != "GET" &&
        req.method != "HEAD" &&
        req.method != "PUT" &&
        req.method != "POST" &&
        req.method != "TRACE" &&
        req.method != "OPTIONS" &&
        req.method != "DELETE") {
          /* Non-RFC2616 or CONNECT which is weird. */
          return (pipe);
    }

    # We only deal with GET and HEAD by default
    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }

    # Bypass shopping cart, checkout and search requests
    if (req.url ~ "/checkout" || req.url ~ "/catalogsearch") {
        return (pass);
    }

    # Bypass health check requests
    # SMILE - use magento healthcheck variable to be consistent into VCL
    if (req.url ~ "/health_check.php") {
        return (pass);
    }

    # Set initial grace period usage status
    set req.http.grace = "none";

    # normalize url in case of leading HTTP scheme and domain
    set req.url = regsub(req.url, "^http[s]?://", "");

    # collect all cookies
    std.collect(req.http.Cookie);

    # Compression filter. See https://www.varnish-cache.org/trac/wiki/FAQ/Compression
    if (req.http.Accept-Encoding) {
        if (req.url ~ "\.(jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf|flv)$") {
            # No point in compressing these (these filetypes are already compressed by nature)
            unset req.http.Accept-Encoding;
        } elsif (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } elsif (req.http.Accept-Encoding ~ "deflate" && req.http.user-agent !~ "MSIE") {
            set req.http.Accept-Encoding = "deflate";
        } else {
            # unkown algorithm
            unset req.http.Accept-Encoding;
        }
    }

    # Remove Google gclid parameters to minimize the cache objects
    set req.url = regsuball(req.url,"\?gclid=[^&]+$",""); # strips when QS = "?gclid=AAA"
    set req.url = regsuball(req.url,"\?gclid=[^&]+&","?"); # strips when QS = "?gclid=AAA&foo=bar"
    set req.url = regsuball(req.url,"&gclid=[^&]+",""); # strips when QS = "?foo=bar&gclid=AAA" or QS = "?foo=bar&gclid=AAA&bar=baz"

    # Static files caching
    if (req.url ~ "^/(pub/)?(media|static)/") {
        # SMILE - Flag query as static resource (useful for better cache strategy if needed)
        set req.http.X-Is-Static = 1;
        # These lines are to avoid multiple versions on cache, of the same file
        unset req.http.Https;
        unset req.http.X-Forwarded-Proto;
        unset req.http.Cookie;
    }

    # Handle Ctrl-F5 by forcing a cache miss
    # On Debian Jessie (Varnish 4.0.2), this will keep the hit counter
    # rising even though it does the right thing
    if (req.http.Cache-Control ~ "no-cache" && client.ip ~ admin) {
        set req.hash_always_miss = true;
    }

    return (hash);
}

sub vcl_hash {
    if (req.http.cookie ~ "X-Magento-Vary=") {
        hash_data(regsub(req.http.cookie, "^.*?X-Magento-Vary=([^;]+);*.*$", "\1"));
    }

    # For multi site configurations to not cache each other's content
    # SMILE - varnish already does this after
    # if (req.http.host) {
    #     hash_data(req.http.host);
    # } else {
    #     hash_data(server.ip);
    # }

    # To cache different pages versions in HTTP / HTTPS and avoid mixed Content
    # Static resources (eg. image) have the same content both in HTTTP/HTTPS
    # We avoid to overload memory cache with different version of same statics
    if (req.http.X-Forwarded-Proto && !req.http.X-Is-Static) {
        hash_data(req.http.X-Forwarded-Proto);
    }
}

sub vcl_synth {
    if (resp.status == 401) {
        set resp.http.WWW-Authenticate = "Basic";
    }
}

sub vcl_backend_response {

    set beresp.grace = 3d;

    if (beresp.http.content-type ~ "text") {
        set beresp.do_esi = true;
    }

    if (bereq.url ~ "\.js$" || beresp.http.content-type ~ "text") {
        set beresp.do_gzip = true;
    }

    if (beresp.http.X-Magento-Debug) {
        set beresp.http.X-Magento-Cache-Control = beresp.http.Cache-Control;
    }

    # Cache only successfully responses and 404s
    if (beresp.status != 200 && beresp.status != 404) {
        set beresp.ttl = 0s;
        set beresp.uncacheable = true;
        return (deliver);
    } elsif (beresp.http.Cache-Control ~ "private") {
        set beresp.uncacheable = true;
        set beresp.ttl = 86400s;
        return (deliver);
    }

    # Validate if we need to cache it and prevent from setting cookie
    if (beresp.ttl > 0s && (bereq.method == "GET" || bereq.method == "HEAD")) {
        unset beresp.http.set-cookie;
    }

   # If page is not cacheable then bypass varnish for 2 minutes as Hit-For-Pass
    if (beresp.ttl <= 0s ||
        beresp.http.Surrogate-control ~ "no-store" ||
        (!beresp.http.Surrogate-Control && beresp.http.Cache-Control ~ "no-cache|no-store") ||
        beresp.http.Vary == "*"
    ) {
        # Mark as Hit-For-Pass for the next 2 minutes
        set beresp.ttl = 120s;
        set beresp.uncacheable = true;
    }

    return (deliver);
}

sub vcl_deliver {
    # Not letting browser to cache non-static files
    if (resp.http.Cache-Control !~ "private" && !req.http.X-Is-Static) {
        set resp.http.Pragma = "no-cache";
        set resp.http.Expires = "-1";
        set resp.http.Cache-Control = "no-store, no-cache, must-revalidate, max-age=0";
    }

    if (client.ip ~ admin) {
        # Set myfrontal ID
        set resp.http.X-Front = server.hostname;
        if (resp.http.x-varnish ~ " ") {
            set resp.http.X-Magento-Cache-Debug = "HIT";
            set resp.http.Grace = req.http.grace;
        } else {
            set resp.http.X-Magento-Cache-Debug = "MISS";
        }
    } else {
        unset resp.http.Age;
        unset resp.http.X-Magento-Debug;
        unset resp.http.X-Magento-Tags;
        unset resp.http.X-Powered-By;
        unset resp.http.Server;
        unset resp.http.X-Varnish;
        unset resp.http.Via;
        unset resp.http.Link;
    }
}

sub vcl_hit {
    if (obj.ttl >= 0s) {
        # Hit within TTL period
        return (deliver);
    }

    if (std.healthy(req.backend_hint)) {
        if (obj.ttl + 60s > 0s) {
            # Hit after TTL expiration, but within grace period
            set req.http.grace = "normal (healthy server)";
            return (deliver);
        } else {
            # Hit after TTL and grace expiration
            return (miss);
        }
    } else {
        # Server is not healthy, retrieve from cache
        set req.http.grace = "unlimited (unhealthy server)";
        return (deliver);
    }
}