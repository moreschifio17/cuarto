<?php
include '../../conexion.php';
include '../../session.php';
$conexion = Conexion::conectar();
$id_cp = $_POST['id_cp'];
$cp_fecha = $_POST['cp_fecha'];
$id_suc = $_SESSION['id_suc'];
$id_art = $_POST['id_art'];
$cantidad = $_POST['cantidad'];
$usuario = $_SESSION['usu_login'];
$operacion = $_POST['operacion'];
$grabar = pg_query($conexion, "SELECT sp_compras_pedidos($id_cp, '$cp_fecha', $id_suc, $id_art, $cantidad, '$usuario', $operacion);");
if($grabar){
    echo pg_last_notice($conexion)."_/_success";
}else{
    echo pg_last_error()."_/_error";
}