<?php
    switch($_POST['action'])
    {
        case 'doLabels':
            echo($_POST['labelout']);
            ini_set('display_errors',1);
            ini_set('display_startup_errors',1);
            error_reporting(-1);
            $slug = $_POST['video'];
            $result = exec("cd ../..; turkic dump ${slug} --xml -o /root/vatic/data/output/${slug}.xml 2>&1; mysqldump -u root --all-databases > data/db.mysql");
            echo $result;
            exit();
    }
?>