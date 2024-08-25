<?php

    $connUpdate=conecta();

    function edad($fecha_nacimiento) {

        // Convierte la fecha de nacimiento a DateTime
        //$fecha_nacimiento_obj = new DateTime($fecha_nacimiento);
        $fecha_nacimiento_obj = DateTime::createFromFormat('d/m/y', $fecha_nacimiento);

        // Calcular la diferencia entre la fecha de nacimiento y la fecha actual
        $diferencia = date_diff(new DateTime(), $fecha_nacimiento_obj);

        // Obtiene la edad
        $edad = $diferencia->y;

        return $edad;
    }

    //actualiza datos de la tabla detalles usuario.
    if (!empty($_POST["btnActualizarDatos"])){
        //verifica si cada textfield tiene datos

        if(!empty($_POST["altura"]) and !empty($_POST["peso"]) and
        !empty($_POST["lesiones"]) and !empty($_POST["medicamentos"]) and
        !empty($_POST["embarazo"]) and !empty($_POST["cirugia"]) and
        !empty($_POST["objetivos"]) and !empty($_POST["edad"])){

            $altura=$_POST["altura"];
            $peso=$_POST["peso"];
            $lesiones=$_POST["lesiones"];
            $medicamentos=$_POST["medicamentos"];
            $embarazo=$_POST["embarazo"];
            $cirugia=$_POST["cirugia"];
            $objetivos=$_POST["objetivos"];
            $edad=$_POST["edad"];

            // Prepara la consulta para actualizar
            $updateSQL = "BEGIN SP_UPDATE_DETALLES_USUARIO(:P_FECHA_NACIMIENTO, :P_ALTURA_PERSONA, :P_PESO_PERSONA, :P_LESIONES, :P_MEDICAMENTOS, :P_EMBARAZO, :P_CIRUGIA, :P_OBJETIVOS, :P_ID_USUARIO); END;";

            // Preparar la conexión y la consulta
            $stidU = oci_parse($connUpdate, $updateSQL);


            $date = DateTime::createFromFormat('Y-m-d', $edad);
            $edad_formateada = $date->format('d/m/y');


            // Ligar variables/paremetros
            oci_bind_by_name($stidU, ':P_FECHA_NACIMIENTO', $edad_formateada);
            oci_bind_by_name($stidU, ':P_ALTURA_PERSONA', $altura);
            oci_bind_by_name($stidU, ':P_PESO_PERSONA', $peso);
            oci_bind_by_name($stidU, ':P_LESIONES', $lesiones);
            oci_bind_by_name($stidU, ':P_MEDICAMENTOS', $medicamentos);
            oci_bind_by_name($stidU, ':P_EMBARAZO', $embarazo);
            oci_bind_by_name($stidU, ':P_CIRUGIA', $cirugia);
            oci_bind_by_name($stidU, ':P_OBJETIVOS', $objetivos);
            oci_bind_by_name($stidU, ':P_ID_USUARIO', $id);
            

            // Ejecutar la consulta
            oci_execute($stidU);

            // Liberar recursos
            oci_free_statement($stidU);
            oci_close($connUpdate);

            echo "<script>window.location.href = '../index.php';</script>"; //Restroceder

        }else{
            echo '<div class="alert alert-warning text-center"> Campos vacios </div>';
        }
    }


?>