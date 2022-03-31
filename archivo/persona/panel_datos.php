<?php
include '../../conexion.php';
$conexion = Conexion::conectar();
$datos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_personas ORDER BY id_per;"));
?>
<div class="card-body">
    <button type="button" class="btn btn-success" onclick="panel_agregar();"><i class="fa fa-plus-circle"></i> Agregar</button>
    <table width="100%" class="table table-bordered" id="tabla_panel_datos">
        <thead>
            <tr>
                <th>#</th>
                <th>Tipo</th>
                <th>C.I.</th>
                <th>R.U.C.</th>
                <th>Nombre</th>
                <th>Apellido</th>
                <th>Nacimiento</th>
                <th>Celular</th>
                <th>Dirección</th>
                <th>Ciudad</th>
                <th>Nacionalidad</th>
                <th>Estado Civil</th>
                <th>Género</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php if(!empty($datos)){ foreach($datos as $d){ ?>
                <tr>
                    <td><?php echo $d['id_per']; ?></td>
                    <td><?php echo $d['tipo_persona']; ?></td>
                    <td><?php echo $d['per_ci']; ?></td>
                    <td><?php echo $d['per_ruc']; ?></td>
                    <td><?php echo $d['per_nombre']; ?></td>
                    <td><?php echo $d['per_apellido']; ?></td>
                    <td><?php echo $d['per_fenaci']; ?></td>
                    <td><?php echo $d['per_celular']; ?></td>
                    <td><?php echo $d['per_direccion']; ?></td>
                    <td><?php echo $d['ciu_descrip']; ?></td>
                    <td><?php echo $d['pais_gentilicio']; ?></td>
                    <td><?php echo $d['ec_descrip']; ?></td>
                    <td><?php echo $d['gen_descrip']; ?></td>
                    <td><?php echo $d['estado']; ?></td>
                    <td>
                        <?php if($d['estado'] == 'ACTIVO'){ ?>
                            <button class="btn btn-warning text-white" onclick="panel_modificar(<?php echo $d['id_per']; ?>);"><i class="fa fa-edit"></i></button>
                            <button class="btn btn-danger" onclick="inactivar_grabar(<?php echo $d['id_per']; ?>);"><i class="fa fa-minus-circle"></i></button>
                        <?php }else{ ?>
                            <button class="btn btn-success" onclick="activar_grabar(<?php echo $d['id_per']; ?>);"><i class="fa fa-check-circle"></i></button>
                        <?php } ?>
                    </td>
                </tr>
            <?php } } ?>
        </tbody>
    </table>
</div>