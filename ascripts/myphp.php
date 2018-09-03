<?php
    function dir_copy($dir_name, $new_dir) {
        if (!is_dir($new_dir)) {
            mkdir($new_dir);
        }
        if (is_dir($dir_name)) {
            if ($dh = opendir($dir_name)) {
                while (($file = readdir($dh)) !== false) {
                    if ($file == "." || $file == "..") {
                        continue;
                    }
                    if (is_dir($dir_name . "/" . $file)) {
                        dir_copy($dir_name . "/" . $file, $new_dir . "/" . $file);
                    } else {
                        copy($dir_name . "/" . $file, $new_dir . "/" . $file);
                    }
                }
                closedir($dh);
            }
        }
        return true;
    }

    switch($_POST['action'])
    {
        case 'doLabels':
            echo($_POST['labelout']);
            ini_set('display_errors',1);
            ini_set('display_startup_errors',1);
            error_reporting(-1);
            $result = exec('cd ../..; turkic dump currentvideo --matlab -o /root/vatic/data/output.mat 2>&1; mysqldump -u root --all-databases > data/db.mysql');
            echo $result;
            exit();

        case 'nextVideo':
            ini_set('display_errors',1);
            ini_set('display_startup_errors',1);
            error_reporting(-1);
            $filepath = $_POST['video'];
            dir_copy("/root/vatic/data/frames_pool/${filepath}", '/root/vatic/data/frames_in');
            $result = shell_exec('sh /root/vatic/next_video.sh');
            echo $result;
            exit();
    }
?>