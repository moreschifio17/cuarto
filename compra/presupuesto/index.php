<?php
    include '../../conexion.php';
    include '../../session.php';
    $conexion = Conexion::conectar();
?>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Cuarto</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="/cuarto/iconos/icono.jpg" type="jpg">
    <link rel="stylesheet" href="/cuarto/estilo/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="/cuarto/estilo/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
    <link rel="stylesheet" href="/cuarto/estilo/descarga/font-google.css">
    <link rel="stylesheet" href="/cuarto/estilo/plugins/sweetalert2/sweetalert2.min.css">
    <link rel="stylesheet" href="/cuarto/estilo/plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="/cuarto/estilo/plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="/cuarto/estilo/descarga/tabla1.min.css">
    <link rel="stylesheet" href="/cuarto/estilo/descarga/tabla2.min.css">
  </head>
  <body class="hold-transition sidebar-mini layout-fixed sidebar-collapse">
    <div class="wrapper">
      <?php include ("../../cabecera.php"); ?>
      <?php include ("../../menu.php"); ?>
      <div class="content-wrapper">
            <div class="content-header">
              <div class="container-fluid">
                <div class="row mb-2">
                  <div class="col-sm-6">
                    <h1 class="m-0 text-dark">Presupuesto del Proveedor</h1>
                    <input type="hidden" id="operacion" value="0">
                    <input type="hidden" id="btn-panel-modificar" data-toggle="modal" data-target="#panel-modificar">
                  </div>
                  <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                      <li class="breadcrumb-item active">Compra</li>
                      <li class="breadcrumb-item active">Presupuesto del Proveedor</li>
                    </ol>
                  </div>
                </div>
              </div>
            </div>
            <section class="content">
                <div class="card">
                    <div class="card-header p-0">
                        <ul class="nav nav-pills ml-auto p-2">
                            <li class="nav-item"><a class="nav-link active" href="#panel-presupuestos" id="btn-panel-presupuestos" data-toggle="tab">Presupuestos</a></li>
                            <li class="nav-item"><a class="nav-link" href="#panel-datos" id="btn-panel-datos" data-toggle="tab">Datos</a></li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content">
                            <div class="tab-pane active" id="panel-presupuestos">
                                <label class="text-danger"><i class="fa fa-exclamation-circle"></i> Cargando...</label>
                            </div>
                            <div class="tab-pane" id="panel-datos">
                                <label class="text-danger"><i class="fa fa-exclamation-circle"></i> Seleccione un presupuesto...</label>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <div class="modal fade" id="panel-modificar">
                
            </div>
        </div>
        <footer class="main-footer">
          <strong>Copyright &copy; 2021 <a href="#">Cuarto</a></strong>
        </footer>
    </div>
    <script src="/cuarto/estilo/plugins/jquery/jquery.min.js"></script>
    <script src="/cuarto/estilo/plugins/jquery-ui/jquery-ui.min.js"></script>
    <script> $.widget.bridge('uibutton', $.ui.button) </script>
    <script src="/cuarto/estilo/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/cuarto/estilo/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
    <script src="/cuarto/estilo/dist/js/adminlte.js"></script>
    <script src="/cuarto/iconos/fontawesome.js"></script>
    <script src="/cuarto/estilo/plugins/fastclick/fastclick.js"></script>
    <script src="/cuarto/estilo/plugins/sweetalert2/sweetalert2.min.js"></script>
    <script src="/cuarto/estilo/plugins/toastr/toastr.min.js"></script>
    <script src="/cuarto/estilo/plugins/select2/js/select2.full.min.js"></script>
    <script src="/cuarto/estilo/descarga/tabla1.min.js"></script>
    <script src="/cuarto/estilo/descarga/tabla2.min.js"></script>
    <script src="/cuarto/estilo/descarga/tabla3.min.js"></script>
    <script src="/cuarto/estilo/descarga/tabla4.min.js"></script>
    <script src="funciones.js"></script>
    <?php include '../../mensaje.php'; ?>
  </body>
</html>