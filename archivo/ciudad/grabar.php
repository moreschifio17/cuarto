<?php
include '../../conexion.php';
include '../../session.php';
$conexion = Conexion::conectar();
$id_ciudad = $_POST['id_ciudad'];
$ciudad_descrip = $_POST['ciu_descrip'];
$id_pais = $_POST['id_pais'];
$usuario = $_SESSION['usu_login'];
$operacion = $_POST['operacion'];
$grabar = pg_query($conexion, "SELECT sp_ciudades($id_ciudad, '$ciudad_descrip','$id_pais', '$usuario', $operacion);");
if($grabar){
    echo pg_last_notice($conexion)."_/_success";
}else{
    echo pg_last_error()."_/_error";
}