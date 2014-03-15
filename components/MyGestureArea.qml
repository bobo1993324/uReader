import QtQuick 2.0

MouseArea {
    signal swipeRight;
    signal swipeLeft;
    signal swipeUp;
    signal swipeDown;

//    anchors.fill: parent
    property int startX;
    property int startY;

    onPressed: {
        startX = mouse.x;
        startY = mouse.y;
    }

    onReleased: {
        var deltax = mouse.x - startX;
        var deltay = mouse.y - startY;

        if (Math.abs(deltax) > 50 || Math.abs(deltay) > 50) {
            if (deltax > 30 && Math.abs(deltay) < 30) {
                // swipe right
                swipeRight();
            } else if (deltax < -30 && Math.abs(deltay) < 30) {
                // swipe left
                swipeLeft();
            } else if (Math.abs(deltax) < 30 && deltay > 30) {
                // swipe down
                swipeDown();
            } else if (Math.abs(deltax) < 30 && deltay < 30) {
                // swipe up
                swipeUp();
            }
        }
    }
}
