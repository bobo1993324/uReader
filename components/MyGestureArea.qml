import QtQuick 2.0
import Ubuntu.Components 0.1
MouseArea {

    signal swipeRight;
    signal swipeLeft;
    signal swipeUp;
    signal swipeDown;

    signal realClicked(variant mouse);

    property int startX;
    property int startY;

    property int threshold1: units.gu(6)
    property int threshold2: units.gu(4)
    onPressed: {
        startX = mouse.x;
        startY = mouse.y;
    }

    onReleased: {
        var deltax = mouse.x - startX;
        var deltay = mouse.y - startY;

        if (Math.abs(deltax) > threshold1 || Math.abs(deltay) > threshold1) {
            if (deltax > threshold2 && Math.abs(deltay) < threshold2) {
                // swipe right
                swipeRight();
            } else if (deltax < -threshold2 && Math.abs(deltay) < threshold2) {
                // swipe left
                swipeLeft();
            } else if (Math.abs(deltax) < threshold2 && deltay > threshold2) {
                // swipe down
                swipeDown();
            } else if (Math.abs(deltax) < threshold2 && deltay < threshold2) {
                // swipe up
                swipeUp();
            }
        } else {
            realClicked(mouse);
        }
    }
}
