var classe = $("#<%= dom_id(@classe) %>")
var adozioniGroup = $(".adozioni-grouped")
var adozioniBox = $(".<%= dom_id(@cliente) %>.adozioni-box");

console.log(adozioniBox);

if (classe != null) {
  classe.replaceWith("<%= j render 'classi/classe', c: @classe, coef: @classe.cliente.max_classi %>");
  $('#<%= dom_id(@classe) %> .on_the_spot_editing').each(initializeOnTheSpot);
};


if (adozioniGroup.length != 0) {
  $(".adozione-cliente.<%= dom_id(@adozioni.first.classe.cliente) %>").replaceWith("<%= j render 'adozioni/adozione_cliente', cliente: @cliente, a: @adozioni, stato: @adozioni.first.stato %>");
};


if (adozioniBox.length != 0) {
  adozioniBox.replaceWith("<%= j @cliente_presenter.adozioni_box %>");
};