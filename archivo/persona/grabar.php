<?php
include '../../conexion.php';
include '../../session.php';
$conexion = Conexion::conectar();
$id_per = $_POST['id_per'];
$per_ruc = $_POST['per_ruc'];
$per_ci = $_POST['per_ci'];
$per_nombre = $_POST['per_nombre'];
$per_apellido = $_POST['per_apellido'];
$per_direccion = $_POST['per_direccion'];
$per_correo = $_POST['per_correo'];
$per_fenaci = $_POST['per_fenaci'];
$per_celular = $_POST['per_celular'];
$per_fisica = $_POST['per_fisica'];
$id_ciudad = $_POST['id_ciudad'];
$id_ec = $_POST['id_ec'];
$id_gen = $_POST['id_gen'];
$usuario = $_SESSION['usu_login'];
$operacion = $_POST['operacion'];
$grabar = pg_query($conexion, "SELECT sp_personas($id_per, '$per_ruc', '$per_ci', '$per_nombre', '$per_apellido', '$per_direccion', '$per_correo', '$per_fenaci', '$per_celular', '$per_fisica', $id_ciudad, $id_ec, $id_gen, '$usuario', $operacion);");
if($grabar){
    echo pg_last_notice($conexion)."_/_success";
}else{
    echo pg_last_error()."_/_error";
}