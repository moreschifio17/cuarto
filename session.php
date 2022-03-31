<?php
session_start();
if(isset($_SESSION['id_usu'])){
    $conexion = Conexion::conectar();
    $resultado = pg_fetch_all(pg_query($conexion,"SELECT * FROM v_usuarios WHERE id_usu = ".$_SESSION['id_usu']));
    $_SESSION['usu_login'] = $resultado[0]['usu_login'];
    $_SESSION['usu_imagen'] = $resultado[0]['usu_imagen'];
    $_SESSION['id_gru'] = $resultado[0]['id_gru'];
    $_SESSION['id_fun'] = $resultado[0]['id_fun'];
    $_SESSION['id_suc'] = $resultado[0]['id_suc'];
    $_SESSION['id_car'] = $resultado[0]['id_car'];
    $_SESSION['car_descrip'] = $resultado[0]['car_descrip'];
    $_SESSION['gru_descrip'] = $resultado[0]['gru_descrip'];
    $_SESSION['suc_ruc'] = $resultado[0]['suc_ruc'];
    $_SESSION['suc_nombre'] = $resultado[0]['suc_nombre'];
    $_SESSION['suc_direccion'] = $resultado[0]['suc_direccion'];
    $_SESSION['suc_celular'] = $resultado[0]['suc_celular'];
    $_SESSION['suc_correo'] = $resultado[0]['suc_correo'];
    $_SESSION['suc_ubicacion'] = $resultado[0]['suc_ubicacion'];
    $_SESSION['suc_imagen'] = $resultado[0]['suc_imagen'];
    $_SESSION['per_ruc'] = $resultado[0]['per_ruc'];
    $_SESSION['per_ci'] = $resultado[0]['per_ci'];
    $_SESSION['per_nombre'] = $resultado[0]['per_nombre'];
    $_SESSION['per_apellido'] = $resultado[0]['per_apellido'];
    $_SESSION['per_direccion'] = $resultado[0]['per_direccion'];
    $_SESSION['per_correo'] = $resultado[0]['per_correo'];
    $_SESSION['per_fenaci'] = $resultado[0]['per_fenaci'];
    $_SESSION['per_celular'] = $resultado[0]['per_celular'];
    $_SESSION['id_ciudad'] = $resultado[0]['id_ciudad'];
    $_SESSION['id_ec'] = $resultado[0]['id_ec'];
    $_SESSION['id_gen'] = $resultado[0]['id_gen'];
    $_SESSION['id_pais'] = $resultado[0]['id_pais'];
    $_SESSION['ciu_descrip'] = $resultado[0]['ciu_descrip'];
    $_SESSION['pais_descrip'] = $resultado[0]['pais_descrip'];
    $_SESSION['pais_gentilicio'] = $resultado[0]['pais_gentilicio'];
    $_SESSION['pais_codigo'] = $resultado[0]['pais_codigo'];
    $_SESSION['ec_descrip'] = $resultado[0]['ec_descrip'];
    $_SESSION['gen_descrip'] = $resultado[0]['gen_descrip'];
    $_SESSION['gen_descrip'] = $resultado[0]['gen_descrip'];

}else{
    header("Location: /cuarto");
    $_SESSION['mensaje'] = "DEBES INICIAR SESION";
}
