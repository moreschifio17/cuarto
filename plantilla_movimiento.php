
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Sysgrafica</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="/movimiento/iconos/icono.jpg" type="jpg">
    <link rel="stylesheet" href="/movimiento/estilo/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="/movimiento/estilo/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
    <link rel="stylesheet" href="/movimiento/estilo/descarga/font-google.css">
    <link rel="stylesheet" href="/movimiento/estilo/plugins/sweetalert2/sweetalert2.min.css">
    <link rel="stylesheet" href="/movimiento/estilo/plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="/movimiento/estilo/plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="/movimiento/estilo/descarga/tabla1.min.css">
    <link rel="stylesheet" href="/movimiento/estilo/descarga/tabla2.min.css">
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
                <h1 class="m-0 text-dark">Movimiento</h1>
                <input type="hidden" id="operacion" value="0">
              </div>
              <div class="col-sm-6">
                <ol class="breadcrumb float-sm-right">
                  <li class="breadcrumb-item active">Modulo</li>
                  <li class="breadcrumb-item active">Movimiento</li>
                </ol>
              </div>
            </div>
          </div>
        </div>
        <section class="content">
            <div class="card">
                <div class="card-header p-0">
                    <ul class="nav nav-pills ml-auto p-2">
                        <li class="nav-item"><a class="nav-link active" href="#panel-movimiento" id="btn-panel-movimiento" data-toggle="tab">Movimiento</a></li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="tab-pane active" id="panel-movimiento">
                            <label class="text-danger"><i class="fa fa-exclamation-circle"></i> Cargando...</label>
                        </div>
                    </div>
                </div>
            </div>
        </section>
      </div>
      <footer class="main-footer">
        <strong>Copyright &copy; 2021 <a href="#">Movimiento</a></strong>
      </footer>
    </div>
    <script src="/movimiento/estilo/plugins/jquery/jquery.min.js"></script>
    <script src="/movimiento/estilo/plugins/jquery-ui/jquery-ui.min.js"></script>
    <script> $.widget.bridge('uibutton', $.ui.button) </script>
    <script src="/movimiento/estilo/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/movimiento/estilo/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
    <script src="/movimiento/estilo/dist/js/adminlte.js"></script>
    <script src="/movimiento/iconos/fontawesome.js"></script>
    <script src="/movimiento/estilo/plugins/fastclick/fastclick.js"></script>
    <script src="/movimiento/estilo/plugins/sweetalert2/sweetalert2.min.js"></script>
    <script src="/movimiento/estilo/plugins/toastr/toastr.min.js"></script>
    <script src="/movimiento/estilo/plugins/select2/js/select2.full.min.js"></script>
    <script src="/movimiento/estilo/descarga/tabla1.min.js"></script>
    <script src="/movimiento/estilo/descarga/tabla2.min.js"></script>
    <script src="/movimiento/estilo/descarga/tabla3.min.js"></script>
    <script src="/movimiento/estilo/descarga/tabla4.min.js"></script>
  </body>
</html>