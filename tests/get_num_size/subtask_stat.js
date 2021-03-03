;(function (){

   /***
    * subtask watcher js sdk
    */
    var storage = window.localStorage;

    var subtask  = {
        "VERSION" : "v1.0"
    }

    subtask.commands = {

    }

    subtask.configure = function (config) {
        if(!config.master_ip) {
           var master_ip = storage.getItem("master_ip");
           if(!master_ip) {
                console.error("not find the master_ip in config");
                return ;
           } 
        } 
        subtask.master_ip = config.master_ip;
    }

    subtask.try_connect = function () {

    }

    subtask.keep_alive = function () {

    }

    return subtask;
})();