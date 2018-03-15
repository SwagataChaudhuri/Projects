function notificationPermissions() {
    if (!("Notification" in window)) {
        console.warn("Browser does not support desktop notifications");
    }
    else if (Notification.permission !== "denied") {
        Notification.requestPermission(function (permission) {
            if (!('permission' in Notification)) {
                Notification.permission = permission;
            }
        });
    }
    notifyMe();
}
function notifyMe() {
    setTimeout(function () {
        if (!("Notification" in window)) {
            alert("This browser does not support desktop notification");
        }
        else if (Notification.permission === "granted") {
            var options = {
                body: "Introducing Personalized Enterprise Search Experience!!",
                icon: "Icon.png",
                dir: "ltr"
            };
            var notification = new Notification("Hi there", options);
        }
    }, 5000);
}