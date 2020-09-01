define([
    'jquery',
    'Magento_Ui/js/modal/modal'
], function ($, modal) {
    var options = {
        'type': 'popup',
        'title': 'Sign Up for Exclusive Offers',
        'modalClass': 'subscribe-modal-popup',
        'responsive': true,
        'innerScroll': true,
        'buttons': false
    };

    $(document).ready(function () {

        if ($('body').hasClass('checkout-index-index') === false) {
            setTimeout(function () {
                var popup = modal(options, $('.newsletter-subscribe-modal'));
                $(".newsletter-subscribe-modal").modal("openModal");
                $.cookie('subscribe_popup', true);
            }, 1000);
        }
    });
});