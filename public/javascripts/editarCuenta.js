var ModelCuenta = function(){
	var main = this;
	var usuarioUri = "http://localhost:3000/api/usuario";
  main.usuarioLogeado = {
    idUsuarioLogeado: ko.observable(),
    nickUsuarioLogeado: ko.observable()
  }

  function ajaxHelper(uri, method, data) {
    return $.ajax({
      url : uri,
      type: method,
      dataType: 'json',
      contentType: 'application/json',
      data: data ? JSON.stringify(data) : null
    }).fail(function(jqXHR, textStatus, errorThrown){
      console.log(errorThrown);
    })
  }

  main.getUsuarioLogeado = function() {
    ajaxHelper(usuarioUri + "/usuarioActual" , 'GET').done(function(data) {
      main.usuarioLogeado.idUsuarioLogeado(data.id);
      main.usuarioLogeado.nickUsuarioLogeado(data.nick) ;
    });
  }

  main.editar = function(){

  }

  main.getUsuarioLogeado();

}
$(document).ready(function() {
  var edit = new ModelCuenta();
  ko.applyBindings(edit);
});