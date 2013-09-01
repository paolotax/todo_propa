var classe = $("#<%= dom_id(@classe) %>")
var adozioniGroup = $(".adozioni-grouped")

if (classe != null) {
	classe.replaceWith("<%= j render 'classi/classe', c: @classe, coef: @classe.cliente.max_classi %>");
	$('#<%= dom_id(@classe) %> .on_the_spot_editing').each(initializeOnTheSpot);
};


if ($(".adozioni-grouped").length != 0) {
	$(".adozione-cliente.<%= dom_id(@adozioni.first.classe.cliente) %>").replaceWith("<%= j render 'adozioni/adozione_cliente', cliente: @adozioni.first.classe.cliente, a: @adozioni, stato: @adozioni.first.stato %>");
};