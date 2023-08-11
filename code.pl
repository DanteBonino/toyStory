%Base de conocimiento
% Relaciona al dueño con el nombre del juguetey la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(sam, jessie, 3).
duenio(sacatronic, soldados,20).
duenio(sacatronic, monitosEnBarril, 50).


% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial,[original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa,caraDePapa([original(pieIzquierdo),original(pieDerecho),repuesto(nariz)])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).

% Dice si una persona es coleccionista
esColeccionista(sam).

%Punto 1:
%a)
tematica(NombreJuguete,Tematica):-
    juguete(NombreJuguete,FormaJuguete),
    tematicaFormaJuguete(FormaJuguete,Tematica).

tematicaFormaJuguete(deTrapo(Tematica),Tematica).
tematicaFormaJuguete(deAccion(Tematica,_),Tematica).
tematicaFormaJuguete(miniFiguras(Tematica,_),Tematica).
tematicaFormaJuguete(caraDePapa(_),caraDePapa).

%b)
esDePlastico(Juguete):-
    juguete(Juguete,Forma),
    forma(Forma,NombreForma),
    formasDePlastico(NombreForma).

formasDePlastico(miniFiguras).
formasDePlastico(caraDePapa).

%c)
esDeColeccion(Juguete):-
    juguete(Juguete,FormaJuguete),
    formaDeColeccion(FormaJuguete).

formaDeColeccion(deTrapo(_)).
formaDeColeccion(Forma):-
    esDeAccionOCaraDePapa(Forma),
    esRaro(Forma).

esDeAccionOCaraDePapa(Forma):-
    forma(Forma,NombreForma),
    formasDeColeccionRaras(NombreForma).

formasDeColeccionRaras(caraDePapa).
formasDeColeccionRaras(deAccion).

forma(deTrapo(_),deTrapo).
forma(deAccion(_,_),deAccion).
forma(miniFiguras(_,_),miniFiguras).
forma(caraDePapa(_),caraDePapa).

%Punto 2:
amigoFiel(Duenio,Juguete):-
    jugueteNoDePlasticoDe(Duenio, Juguete, Anios),
    forall(jugueteNoDePlasticoDe(Duenio,_,Anio), Anios >= Anio).

jugueteNoDePlasticoDe(Duenio, Juguete, Anio):-
    duenio(Duenio, Juguete, Anio),
    not(esDePlastico(Juguete)).

%Punto 3:
superValioso(Juguete):-
    esDeColeccion(Juguete),
    noLoTieneUnColeccionista(Juguete),
    todasSusPiezasSonOriginales(Juguete).

todasSusPiezasSonOriginales(Juguete):-
    juguete(Juguete,Forma),
    partes(Forma, Partes),
    forall(member(Parte, Partes), esOriginal(Parte)).

partes(deTrapo(_),[]). %Preguntar esto -> Funciona, pero semánticamente quizá no es lo mejor
partes(deAccion(_,Partes),Partes).
partes(miniFiguras(_,Partes),Partes).
partes(caraDePapa(Partes),Partes).

esOriginal(original(_)).

noLoTieneUnColeccionista(Juguete):-
    esColeccionista(Coleccionista),
    not(duenio(Coleccionista,Juguete,_)).

%Punto 4:
duoDinamico(Duenio, Juguete, OtroJuguete):-
    duenio(Duenio,Juguete,_),
    duenio(Duenio,OtroJuguete,_),
    Juguete \= OtroJuguete,
    buenaPareja(Juguete,OtroJuguete).

buenaPareja(woody,buzz).%Se podría hacer como una regla, pero no sé si es mejor.
buenaPareja(buzz,woody).
buenaPareja(Juguete,OtroJuguete):-
    tematica(Juguete,Tematica),
    tematica(OtroJuguete,Tematica).

%Punto 5:
felicidad(Duenio, FelicidadTotalOtorgada):-
    felicidadesDeJuguetes(Duenio,Felicidades),
    sum_list(Felicidades, FelicidadTotalOtorgada).

felicidadesDeJuguetes(Persona,Felicidades):-
    duenio(Persona,_,_),
    findall(Felicidad, felicidadPorJuguete(Persona, Felicidad), Felicidades).

felicidadPorJuguete(Duenio,Felicidad):-
    duenio(Duenio,Juguete,_),
    juguete(Juguete,Forma),
    felicidadJuguete(Juguete,Forma,Felicidad).

felicidadJuguete(_,miniFiguras(_,CantidadFiguras), Felicidad):-
    Felicidad is CantidadFiguras * 20.
felicidadJuguete(_,caraDePapa(Piezas), Felicidad):-
    findall(FelicidadPorPieza, felicidadPieza(Piezas, FelicidadPorPieza), Felicidades),
    sum_list(Felicidades, Felicidad).
felicidadJuguete(_,deTrapo(_),100).
felicidadJuguete(Juguete,deAccion(_,_), Felicidad):-
    felicidadJuguetesDeAccion(Juguete, Felicidad).

%Predicados que se usan en felicidadJuguete (caraDePapa):
felicidadPieza(Piezas,Felicidad):-
    member(Pieza,Piezas),
    valorFelicidadDePieza(Pieza,Felicidad).

valorFelicidadDePieza(Pieza,5):-
    esOriginal(Pieza).
valorFelicidadDePieza(Pieza,8):-
    not(esOriginal(Pieza)).

%Predicados que se usan en felicidadJuguete (deAccion):
felicidadJuguetesDeAccion(Juguete,Felicidad):-
    not(esDeColeccionYLoTieneUnColeccionista(Juguete)),
    felicidadJuguete(_,deTrapo(_),Felicidad).
felicidadJuguetesDeAccion(Juguete,120):-
    esDeColeccionYLoTieneUnColeccionista(Juguete).

esDeColeccionYLoTieneUnColeccionista(Juguete):-
    esDeColeccion(Juguete),
    not(noLoTieneUnColeccionista(Juguete)).

%Punto 6:
puedeJugarCon(Persona, Juguete):-
    juguete(Juguete,_),
    esDuenioOLePuedenPrestar(Persona,Juguete).

esDuenioOLePuedenPrestar(Persona,Juguete):-
    duenio(Persona,Juguete,_).
esDuenioOLePuedenPrestar(Persona,Juguete):-
    puedePrestarle(OtraPersona, Persona),
    puedeJugarCon(OtraPersona,Juguete).

puedePrestarle(UnaPersona, OtraPersona):-
    cantidadJuguetes(UnaPersona,CantidadJuguetesPersona),
    cantidadJuguetes(OtraPersona,CantidadJuguetesOtraPersona),
    CantidadJuguetesPersona > CantidadJuguetesOtraPersona.

cantidadJuguetes(Persona,Cantidad):-
    felicidadesDeJuguetes(Persona, Felicidades), %No tiene mucho sentido, pero era para no hacer otro findall distinto y usar un predicado que ya me unificaba a la persona y me daba algo contable.
    length(Felicidades, Cantidad).

formaDeJuguete(Juguete,Forma):-
    juguete(Juguete, FormaDeJuguete),
    forma(FormaDeJuguete,Forma).