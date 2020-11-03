import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12
import QtQuick.Controls.Styles 1.2
import QtQuick.VirtualKeyboard 2.4
import QtQuick.Controls 2.3
import QtQuick.VirtualKeyboard.Settings 2.2
import QtQuick.Layouts 1.12
import "content"

Window {
    id: windowMain
    visible: true
    width: 800
    height: 480

    Rectangle {
        id:streaming
        objectName: "streaming"
        width: 800
        height: 480
        z:40
        color: "black"


        MediaPlayer {
            id: player
            //source: "gst-pipeline: videotestsrc ! qtvideosink"
            source: "gst-pipeline: playbin uri=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm"
            //source: "gst-pipeline: nvarguscamerasrc ! video/x-raw,width=800,height480 ! autovideoconvert ! qtvideosink"
            //source: "file:///home/jnano/Desktop/build-VideoOutput-Desktop-Release/file_example_WEBM_480_900KB.webm"
            //source: "file:///home/ulas/Desktop/file_example_WEBM_1920_3_7MB.webm"
            autoPlay: true

        }

        VideoOutput {
            id: videoOutput
            source: player
            anchors.fill: parent
        }
//        Item {
//          y: 300;
//          property string text: " this is Qt streaming! "
//          property string spacing: "      "
//          property string combined: text + spacing + text
//          property string display: combined.substring(step) + combined.substring(0, step)
//          property int step: 0

//          Timer {
//            interval: 200
//            running: true
//            repeat: true
//            onTriggered: parent.step = (parent.step + 1) % parent.combined.length
//          }

//          Text {
//            text: parent.display
//            color: "red"
//            font.family: fontAwesomeSolid.name
//            fontSizeMode: Text.Fit
//            font.pointSize: 40
//          }
//        }

        signal qmlSignal()

        TapHandler{
            onTapped: {
                console.log("rec1");
               // settigs.visible = true
                if(!password.visible || (password.opacity === 0))
                    streaming.qmlSignal();
                    //settigs.visible = false

            }
        }

    }


    Rectangle {
        id: settigs
        objectName: "settings"
        width: 100
        height: 100
        color:"transparent"
        Image
        {
        //source:"qrc:/settings.png"
        source:"file:/home/jnano/Downloads/settings.png"
        //source:"file:/home/ulas/Desktop/settings.png"
        fillMode:  Image.Tile
        anchors.fill: parent
        opacity: 0.3
        sourceSize.width: 100
        sourceSize.height: 100
        }
        y: windowMain.height - height -10
        x: windowMain.width - width - 30
        visible: false



        TapHandler{
            onTapped: {
                console.log("rec2");
                password.visible = true;
                password.opacity = 1.0
                password.z = 90;
                //passTextField.z = 60;
                streaming.z = -1;
                passTextField.visible = true;
                back.visible = true;
            }
        }
    }

    Flickable
    {
        id: flickable
        anchors.fill: parent
        //anchors.margins: 20
        anchors.bottomMargin: inputPanel.visible ? inputPanel.height : anchors.margins
        contentWidth: password.implicitWidth
        contentHeight: password.implicitHeight
        flickableDirection: Flickable.VerticalFlick

    Rectangle
    {
        id:password
        objectName: "password"
        width: parent.width
        height: parent.height
        color: "transparent"
        //opacity: 0.3
        visible: false
        z: -1;

//        Rectangle{
//            width: 800
//            height: 480
//            color: "transparent"
//            //opacity: 0.3
//            y:100
//        }

        Rectangle
        {
            id: title
            y: 14
            color: "blue"
            width: 800
            height: 40
            z:99;
            Rectangle
            {
                id:back
                objectName: "back"
                width: 40
                height: 40
                anchors.right: parent.right
                color:"transparent"

                    Image
                    {
                    //source:"qrc:/back.png"
                    source:"file:/home/jnano/Downloads/back.png"
                    //source:"file:/home/ulas/Desktop/back.png"
                    fillMode:  Image.PreserveAspectFit
                    anchors.fill: parent
                    sourceSize.width: 40
                    sourceSize.height: 40
                    }
                    signal qmlSignalPass()
                    TapHandler{
                        onTapped: {
                            console.log("back");
                            password.opacity = 0;
                            password.z = -2;
                            passTextField.visible = false;
                            streaming.z = 30
                            //password.visible = false; // this do not work because of parent child relationship
                            //so visibility shoul be handled by z and opacity property
                            //back.qmlSignalPass(); // same as above, c++ part do not handle
                        }
                    }
            }

            Text
            {
                text:"PIN"
                font.family: "Helvetica"
                font.pixelSize: 26
                color: "white"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        TapHandler{
            onTapped: {
                console.log("rec3");
                inputPanel.visible = false;
                passTextField.focus = false;
            }
        }
            TextField {
                id: passTextField
                objectName: "passTextField"
                width: 300
                y:190
                x:250
                placeholderText: "Enter PIN"
                echoMode: TextInput.Password

                onEditingFinished :
                {
                    console.log("enter is pressed")
                    console.log(passTextField.text)

                    stackViewRect.visible = true
                    stackViewRect.opacity = 1;
                    stackViewRect.z = 40;
                    password.opacity = 0;
                    password.z = -1;
                    passTextField.visible = false;
                    //back.z = -1
                    //back.opacity = 0;
                    back.visible = false;
                    //editingFinished() signal will be signalled automatically
                }

                onActiveFocusChanged: {
                    if(activeFocus)
                    {
                        inputPanel.visible = activeFocus
                        var posWithinFlicable = mapToItem(password,0, height/2);
                        flickable.contentY = posWithinFlicable.y - flickable.height/2;
                    }
                }
            }

    }
}





//    Text
//    {
//        text:"PIN"
//        font.family: "Helvetica"
//        font.pixelSize: 26
//        color: "white"
//        anchors.top: parent.top
//        anchors.bottom: parent.bottom
//        anchors.horizontalCenter: parent.horizontalCenter
//    }
//    Rectangle
//    {
//        id: titleSettings
//        y: 14
//        color: "blue"
//        width: 800
//        height: 40
//        Rectangle
//        {
//            id:backSettings
//            objectName: "back"
//            width: 40
//            height: 40
//            anchors.right: parent.right
//            color:"transparent"

//                Image
//                {
//                source:"file:/home/jnano/Downloads/back.png"
//                //source:"file:/home/ulas/Desktop/back.png"
//                fillMode:  Image.PreserveAspectFit
//                anchors.fill: parent
//                sourceSize.width: 40
//                sourceSize.height: 40
//                }
//                //signal qmlSignalPass()
//                TapHandler{
//                    onTapped: {
//                        console.log("back");
//                        password.opacity = 0;
//                        password.z = -1;
//                        passTextField.visible = false;
//                        //password.visible = false; // this do not work because of parent child relationship
//                        //so visibility shoul be handled by z and opacity property
//                        //back.qmlSignalPass(); // same as above, c++ part do not handle
//                    }
//                }
//        }
//    }




        Rectangle
        {
            id: stackViewRect
            width: parent.width
            height: parent.height
            color:"transparent"
            //opacity: 0.3
            visible: false
            //y: 200

          Rectangle{
              width: parent.width
              height: parent.height
              color:"white"
              opacity: 0.3
          }


          Rectangle
          {
              id: titleSettings
              y: 14
              color: "blue"
              width: 800
              height: 40

              Rectangle
              {
                  id:backSettings
                  objectName: "back"
                  width: 40
                  height: 40
                  anchors.right: parent.right
                  color:"transparent"

                      Image
                      {
                      //source:"qrc:/back.png"
                      source:"file:/home/jnano/Downloads/back.png"
                      //source:"file:/home/ulas/Desktop/back.png"
                      fillMode:  Image.PreserveAspectFit
                      anchors.fill: parent
                      sourceSize.width: 40
                      sourceSize.height: 40
                      }
                      //signal qmlSignalPass()
                      TapHandler{
                          onTapped: {
                              console.log("back2");
                              stackViewRect.opacity = 0;
                              stackViewRect.z = -1;
                              streaming.z = 30
                              //passTextField.visible = false;
                              //password.visible = false; // this do not work because of parent child relationship
                              //so visibility shoul be handled by z and opacity property
                              //back.qmlSignalPass(); // same as above, c++ part do not handle
                          }
                      }
              }
          }

          Text
          {
              text:"SETTINGS"
              font.family: "Helvetica"
              font.pixelSize: 26
              color: "white"
              anchors.top: titleSettings.top
              anchors.bottom: titleSettings.bottom
              anchors.horizontalCenter: titleSettings.horizontalCenter
          }

            Rectangle{
                id: stackViewRect2
                width: parent.width
                height: parent.height
                color:"transparent"
                //opacity: 0.3
                y: 60

                  ListModel {
                      id: pageModel

                      ListElement {
                          title: "Network"
                          page: "network.qml"
                      }
                      ListElement {
                          title: "Local"
                          page: "Local.qml"
                      }
                      ListElement {
                          title: "Wifi"
                          page: "Wifi.qml"
                      }
                      ListElement {
                          title: "Admin"
                          page: "Admin.qml"
                      }
                  }


            StackView {
                id: stackView

                anchors.fill: parent
                // Implements back key navigation
                focus: true


                Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                                     stackView.pop();
                                     event.accepted = true;
                                 }



                    initialItem: Item {
                        ListView {
                            //contentWidth: parent.width
                            //contentHeight: parent.height

                            //flickDeceleration: Flickable.
                            //flickableDirection: Flickable.AutoFlickDirection
                            model: pageModel
                            //highlightRangeMode: ListView.ApplyRange
                            orientation: ListView.Horizontal
                            //orientation: ListView.DragOverBounds
                            anchors.fill: parent

                            spacing: 10
                            //highlightRangeMode: ListView.StrictlyEnforceRange
                            delegate: DesignDelegate {
                                y: 40
                                text: title
                                Image {
                                    id: example
                                    width: 250
                                    height: 250
                                    fillMode: Image.PreserveAspectFit
                                    //source:"qrc:/"+title+".png"
                                    source:"file:/home/jnano/Downloads/"+title+".png"
                                    //source:"file:/home/ulas/Desktop/"+title+".png"
                                }
                                onClicked: stackView.push(Qt.resolvedUrl(page))
                            }

                        }
                    }

            }
        }

        }





    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: windowMain.height
        width: windowMain.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: windowMain.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Binding {
            target: InputContext
            property: "animating"
            value: inputPanelTransition.running
        }
        AutoScroller {}
    }

}
