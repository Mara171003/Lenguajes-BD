<?php

function edad($fecha_nacimiento) {

    // Convierte la fecha de nacimiento a DateTime
    $fecha_nacimiento_obj = new DateTime($fecha_nacimiento);

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

        $updateSQL = "BEGIN SP_UPDATE_DETALLES_USUARIO(:P_ALTURA_PERSONA,:P_PESO_PERSONA,:P_LESIONES,:P_MEDICAMENTOS,:P_EMBARAZO,:P_CIRUGIA,:P_OBJETIVOS,P_FECHA_NACIMIENTO,:P_ID_USUARIO); END;";
        
        // Preparar la conexión y la consulta
        $stid = oci_parse($conn, $updateSQL);
        
        // Ligar variables/paremetros
        oci_bind_by_name($stid, ':P_ALTURA_PERSONA', $altura);
        oci_bind_by_name($stid, ':P_PESO_PERSONA', $peso);
        oci_bind_by_name($stid, ':P_LESIONES', $lesiones);
        oci_bind_by_name($stid, ':P_MEDICAMENTOS', $medicamentos);
        oci_bind_by_name($stid, ':P_EMBARAZO', $embarazo);
        oci_bind_by_name($stid, ':P_CIRUGIA', $cirugia);
        oci_bind_by_name($stid, ':P_OBJETIVOS', $objetivos);
        oci_bind_by_name($stid, ':P_FECHA_NACIMIENTO', $edad);
        oci_bind_by_name($stid, ':P_ID_USUARIO', $id);
        

        // Ejecutar la consulta
        oci_execute($stid);

        // Liberar recursos
        oci_free_statement($stid);
        oci_close($conn);

        echo "<script>window.location.href = '../usuario/perfilUsuario.php?id=$id';</script>"; //Restroceder

    }else{
        echo '<div class="alert alert-warning text-center"> Campos vacios </div>';
    }
}

//Agrega datos de la tabla detalles usuario

if (!empty($_POST["btnAgregarDatos"])){
   //verifica si cada textfield tiene datos
    if(!empty($_POST["altura"]) and !empty($_POST["peso"]) and
    !empty($_POST["lesiones"]) and !empty($_POST["medicamentos"]) and
    !empty($_POST["embarazo"]) and !empty($_POST["cirugia"]) and
    !empty($_POST["objetivos"])){

        $altura=$_POST["altura"];
        $peso=$_POST["peso"];
        $lesiones=$_POST["lesiones"];
        $medicamentos=$_POST["medicamentos"];
        $embarazo=$_POST["embarazo"];
        $cirugia=$_POST["cirugia"];
        $objetivos=$_POST["objetivos"];
        $edad=$_POST["edad"];
        $id_usuario=$_SESSION['id'];

        //Insert Detalles
        $sql = Conecta()->query("INSERT INTO detalles_usuario (fecha_nacimiento, altura_persona, peso_persona, lesiones, medicamentos, embarazo, cirugia, objetivos, id_usuario) 
        VALUES ('$edad', '$altura', '$peso', '$lesiones', '$medicamentos', '$embarazo', '$cirugia', '$objetivos', $id_usuario);");

        //--
        $insertSQL = "BEGIN sp_insert_detalles_usuario(:P_FECHA_NACIMIENTO:P_ALTURA_PERSONA:P_PESO_PERSONA,:P_LESIONES,:P_MEDICAMENTOS,:P_EMBARAZO,:P_CIRUGIA,:P_OBJETIVOS,:P_ID_USUARIO,:P_RESULT); END;";
        
        // Preparar la conexión y la consulta
        $stid = oci_parse($conn, $insertSQL);
        
        // Ligar variables/parámetros

        oci_bind_by_name($stid, ':P_FECHA_NACIMIENTO', $fecha_nacimiento);
        oci_bind_by_name($stid, ':P_ALTURA_PERSONA', $altura);
        oci_bind_by_name($stid, ':P_PESO_PERSONA', $peso);
        oci_bind_by_name($stid, ':P_LESIONES', $lesiones);
        oci_bind_by_name($stid, ':P_MEDICAMENTOS', $medicamentos);
        oci_bind_by_name($stid, ':P_EMBARAZO', $embarazo);
        oci_bind_by_name($stid, ':P_CIRUGIA', $cirugia);
        oci_bind_by_name($stid, ':P_OBJETIVOS', $objetivos);
        oci_bind_by_name($stid, ':P_ID_USUARIO', $id_usuario);
        
        // ejecutar la consulta
        oci_execute($stid);
        
        // liberar
        oci_free_statement($stid);
        oci_close($conn);

        echo "<script>window.location.href = '../index.php';</script>";

    }else{
        echo '<div class="alert alert-warning text-center"> Campos vacios </div>';
    }

    
}

?>