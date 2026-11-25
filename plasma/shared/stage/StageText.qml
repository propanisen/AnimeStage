import QtQuick

Text {
    required property var stage
    property bool display: false

    color: stage.text
    font.family: stage.font
    font.weight: display ? Font.ExtraBold : Font.Normal
    elide: Text.ElideRight
    renderType: Text.QtRendering
}
