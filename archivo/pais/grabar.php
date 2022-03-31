<?php
include '../../conexion.php';
include '../../session.php';
$conexion = Conexion::conectar();
$id_pais= $_POST['id_pais'];
$pais_descrip= $_POST['pais_descrip'];
$pais_gentilicio= $_POST['pais_gentilicio'];
$pais_codigo= $_POST['pais_codigo'];
$usuario= $_SESSION['usu_login'];
$operacion= $_POST['operacion'];

$grabar= pg_query($conexion, "SELECT sp_paises ($id_pais,'$pais_descrip', '$pais_gentilicio', '$pais_codigo', '$usuario',$operacion);");
if ($grabar) {
    echo pg_last_notice($conexion)."_/_success";
} else {
    echo pg_last_error()."_/_error";
}