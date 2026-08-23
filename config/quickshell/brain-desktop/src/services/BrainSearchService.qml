pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../"


QtObject {

    id: root


    property bool open: false

    property string statusFile: "/tmp/brain_search_status"
    
    property var apps: []

    property string query: ""



    readonly property var results: {

        var q = query.toLowerCase().trim()

        if (q === "")
            return apps


        return apps.filter(function(app){

            return app.name
                .toLowerCase()
                .includes(q)

        })

    }



    property var appLoader: Process {

        command: [
            "python3",
            Quickshell.shellDir + "/src/scripts/list_apps.py"
        ]


        running: false


        stdout: StdioCollector {

            onStreamFinished: {

                try {

                    root.apps = JSON.parse(text)

                }

                catch(e) {

                    root.apps = []

                }

            }

        }

    }



    property var launcher: Process {

        command: []

        running: false

    }

    function saveStatus(value){

        var p = Qt.createQmlObject(
        '
        import Quickshell.Io
        Process {}
        ',
        root
    )

    p.command = [
        "bash",
        "-c",
        "echo " + value + " > /tmp/brain_search_status"
    ]

    p.running = true

}

    function show(){

        root.open = true

        saveStatus("open")

        root.query = ""


        appLoader.running = false

        appLoader.running = true

    }



    function hide(){

        root.open = false

        saveStatus("closed")

        root.query = ""

    }

   function type(char){

       root.query += char

   }

    function launch(exec){

        launcher.command = [
            "bash",
            "-c",
            "setsid " + exec + " >/dev/null 2>&1 &"
        ]


        launcher.running = false

        launcher.running = true


        hide()

    }


}
