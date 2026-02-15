import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell

Item {
    id: calendar
    property var currentDate: new Date()
    property int viewMonth: currentDate.getMonth()
    property int viewYear: currentDate.getFullYear()

    implicitWidth: calendarContent.implicitWidth
    implicitHeight: calendarContent.implicitHeight

    // Helpers
    function getDaysInMonth(month, year) {
        return new Date(year, month + 1, 0).getDate();
    }

    function getFirstDayOfWeek(month, year) {
        return new Date(year, month, 1).getDay();
    }

    function isToday(day, month, year) {
        const today = new Date();
        return day === today.getDate() &&
               month === today.getMonth() &&
               year === today.getFullYear();
    }

    function getMonthName(month) {
        const months = [
            "Januray", "February", "March",
            "April", "May", "June", "July",
            "August", "September", "October",
            "November", "December"
        ];
        return months[month];
    }

    function previousMonth(month) {
        if (month === 0) {
            viewMonth = 11;
            viewYear--;
        } else {
            viewMonth--;
        }
    }

    function nextMonth(month) {
        if (month === 11) {
            viewMonth = 0;
            viewYear++;
        } else {
            viewMonth++;
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            calendar.currentDate = new Date();
        }
    }

    Column {
        id: calendarContent
        anchors.centerIn: parent
        spacing: 16

        // Full Date Header
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(calendar.currentDate, "dddd, MMMM d yyyy")
            color: "#aaaaaa"
            font.pixelSize: 16
            font.family: "monospace"
            font.bold: true
        }

        // Separator
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.implicitWidth
            height: 2
            radius: 2
            opacity: 0.5
            color: "#aaaaaa"
        }
        
        // Month Navigation
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            // Previous Month Button
            Rectangle {
                width: 32
                height: 32
                radius: 6
                color: prevHover.hovered ? "#2a2a2a" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "<"
                    color: "#aaaaaa"
                    font.pixelSize: 14
                }

                HoverHandler {
                    id: prevHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: calendar.previousMonth()
                }
            }

            // Year Display
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: calendar.getMonthName(calendar.viewMonth) + " " + calendar.viewYear
                color: "#aaaaaa"
                font.pixelSize: 14
                font.family: "monospace"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            // Next Month Button
            Rectangle {
                width: 32
                height: 32
                radius: 6
                color: nextHover.hovered ? "#2a2a2a" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: ">"
                    color: "#aaaaaa"
                    font.pixelSize: 14
                }

                HoverHandler {
                    id: nextHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: calendar.nextMonth()
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 4

            Repeater {
                model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

                Text {
                    width: 36
                    height: 28
                    text: modelData
                    color: "#aaaaaa"
                    font.pixelSize: 11
                    font.family: "monospace"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Grid {
            columns: 7
            spacing: 4

            Repeater {
                model: 42 // 6 weeks max

                Rectangle {
                    width: 36
                    height: 36
                    radius: 6

                    property int offset: calendar.getFirstDayOfWeek(calendar.viewMonth, calendar.viewYear)
                    property int daysInMonth: calendar.getDaysInMonth(calendar.viewMonth, calendar.viewYear)
                    property int dayNumber: index - offset + 1
                    property bool isValidDay: dayNumber > 0 && dayNumber <= daysInMonth
                    property bool isTodayCell: isValidDay && calendar.isToday(dayNumber, calendar.viewMonth, calendar.viewYear)

                    color: {
                        if (!isValidDay) return "transparent";
                        if (isTodayCell) return "#00aaff";
                        if (dayHover.hovered) return "#2a2a2a";
                        return "transparent"
                    }

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: parent.isValidDay ? parent.dayNumber : ""
                        color: parent.isTodayCell ? "#181818" : "#aaaaaa"
                        font.pixelSize: 13
                        font.family: "monospace"
                        font.bold: parent.isTodayCell
                    }

                    HoverHandler {
                        id: dayHover
                        enabled: parent.isValidDay
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
