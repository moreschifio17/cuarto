<?php
include '../../conexion.php';
include '../../session.php';
$conexion = Conexion::conectar();
$id_cpre = $_POST['id_cpre'];
$cpre_fecha = $_POST['cpre_fecha'];
$cpre_validez = $_POST['cpre_validez'];
$cpre_numero = $_POST['cpre_numero'];
$cpre_observacion = $_POST['cpre_observacion'];
$id_suc = $_SESSION['id_suc'];
$id_pro = $_POST['id_pro'];
$id_art = $_POST['id_art'];
$cantidad = $_POST['cantidad'];
$precio = $_POST['precio'];
$id_cp = $_POST['id_cp'];
$usuario = $_SESSION['usu_login'];
$operacion = $_POST['operacion'];
$grabar = pg_query($conexion, "SELECT sp_compras_presupuestos($id_cpre, '$cpre_fecha', '$cpre_validez', $cpre_numero, '$cpre_observacion', $id_suc, $id_pro, $id_art, $cantidad, $precio, $id_cp, '$usuario', $operacion);");
if($grabar){
    echo pg_last_notice($conexion)."_/_success";
}else{
    echo pg_last_error()."_/_error";
}
