// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery-offline

//= require jquery_ujs
//= require chosen.jquery
//= require showdown
//= require jquery.validity

//= require gmaps4rails/gmaps4rails.base.js
//= require gmaps4rails/gmaps4rails.googlemaps.js

//= require on_the_spot
//= require bootstrap
//= require bootstrap-transition
//= require hamlcoffee
//= require jquery.timeago
//= require jquery_nested_form
//= require jquery.soulmate
//= require_tree ../templates
//= require_tree ./application

//= require stuff
//= require demo

//= require gmaps




//pads left
String.prototype.lpad = function(padString, length) {
	var str = this;
    while (str.length < length)
        str = padString + str;
    return str;
}
 
//pads right
String.prototype.rpad = function(padString, length) {
	var str = this;
    while (str.length < length)
        str = str + padString;
    return str;
}



function testCallback(object, value, settings) {
  var converter = new Showdown.converter();
  var html = converter.makeHtml(value);
  $(object).html(html);
}

$.urlParam = function(name){
    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (!results)
    { 
        return 0; 
    }
    return results[1] || 0;
}

function getUrlVars(url)
{
    var vars = [], hash;
    var hashes = url.slice(url.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}