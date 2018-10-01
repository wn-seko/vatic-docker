<?php
    function make_dir($dir_name) {
        if (!is_dir($dir_name)) {
            mkdir($dir_name);
        }
    }

    switch($_POST['action']) {
        case 'doLabels':
            echo($_POST['labelout']);
            ini_set('display_errors',1);
            ini_set('display_startup_errors',1);
            error_reporting(-1);
            $slug = $_POST['video'];
            make_dir("/root/vatic/data/output/${slug}");
            $result = exec("cd ../..; turkic dump ${slug} --xml -o /root/vatic/data/output/${slug}/${slug}.xml 2>&1; mysqldump -u root --all-databases > data/db.mysql");
            echo $result;
            exit();
        case 'doVisualize':
            echo($_POST['labelout']);
            ini_set('display_errors',1);
            ini_set('display_startup_errors',1);
            error_reporting(-1);
            $slug = $_POST['video'];
            make_dir("/root/vatic/data/output/${slug}/annotated_imgs");
            $result = exec("cd ../..; turkic visualize ${slug} /root/vatic/data/output/${slug}/annotated_imgs --merge --renumber --labels 2>&1;");
            echo $result;
            exit();
    }
?>