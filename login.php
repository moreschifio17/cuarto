<?php
session_start();
if (isset($_POST['usuario']) && isset($_POST['contrasena'])) {
    include 'conexion.php';
    $conexion = Conexion::conectar();
    $usuario = $_POST['usuario'];
    $contrasena = $_POST['contrasena'];
    $resultado = pg_fetch_all(pg_query("select * from usuarios where usu_login=trim('$usuario');"));

    if (empty($resultado)) {
        $_SESSION['mensaje'] = "NO EXISTE EL USUARIO";
        $_SESSION['tipo_mensaje'] = "error";
        header('Location:/cuarto');
    } else {
        if ($resultado[0]['usu_pass'] == md5($contrasena)) {
            $_SESSION['id_usu'] = $resultado[0]['id_usu'];
            //$_SESSION['login'] = $resultado[0]['usu_login'];
            header('Location:/cuarto/inicio.php');
        } else {
            $_SESSION['mensaje'] = "LA CONTRASEÑA NO COINCIDE";
            $_SESSION['tipo_mensaje'] = "error";
            header('Location:/cuarto');
        }
    }
} else {
    $_SESSION['mensaje'] = "NO EXISTEN LOS PARAMETROS";
    $_SESSION['tipo_mensaje'] = "error";
    header('Location:/cuarto');
}
