create table PERSONALE (
    tessera                 number(4)              primary key,
    nome                    varchar(15)         not null,
    cognome                 varchar(15)         not null,
    codice_fiscale          char(16)            not null,
    data_di_nascita         date                not null,
    ruolo                   varchar(10)         not null
);

create table STIPENDI (
    codice_busta_paga       number(7)              primary key,
    stipendio_base          number(4,2)              not null,
    premio                  number(3,2)              not null,
    tessera                 number(4)               not null,
    constraint FK_Stipendio foreign key (tessera) references PERSONALE(tessera) ON DELETE SET NULL
);

create table TURNI (
    tessera                 number(4),
    data_turno              date,
    ora_ingresso            date                not null,
    ora_uscita              date                not null,
    ore_di_lavoro           number(3)              not null,
    constraint FK_Turni     foreign key (tessera) references PERSONALE(tessera),
    constraint PK_TURNI     primary key (tessera, data_turno) 
);

create table CLIENTE_ISCRITTO (
    email                   varchar(30)           primary key,
    passwd                  varchar(16)           not null,
    codice_cliente          number(3)                not null
);

create table ORDINE (
    numero_ordine           number(3)               primary key,
    metodo_pagamento        varchar(10)          not null,
    prezzo_tot              number(3,2)               not null,
    tessera                 number(4)               not null,
    email                   varchar(30)             not null,
    constraint FK_Ordine    foreign key (tessera) references PERSONALE(tessera),
    constraint FK_Cliente_iscritto foreign key (email) references CLIENTE_ISCRITTO(email)
);

create table MAGAZZINO (
    cod_prod_magazzino      number(3)               primary key,
    quantita_rimanente      number(4)               not null,
    quantita_disponibile    number(4)               not null,
    categoria_prod          varchar(15)          not null
);

create table INFORMAZIONI_NUTRIZIONALI (
    quantita_per_100gr      number(4) primary key,
    quantita_per_prod       number(4) not null,
    rda                     number(3) not null,
    componente              varchar(15)          not null
);

create table PRODOTTO (
    nome_prodotto           varchar(25)          primary key,
    cod_prod_magazzino      number(3)            not null,
    prezzo                  number(3,2)               not null,
    quantita_per_100gr      number(4)             not null,
    constraint FK_Prodotto  foreign key (cod_prod_magazzino) references MAGAZZINO(cod_prod_magazzino),
    constraint FK_Info_Nutrizionali foreign key (quantita_per_100gr) references INFORMAZIONI_NUTRIZIONALI(quantita_per_100gr)
);

create table PANINI (
    nome_prodotto           varchar(25)          not null,
    constraint  PK_PANINI primary key (nome_prodotto),
    constraint FK_PANINI foreign key(nome_prodotto) references PRODOTTO(nome_prodotto)
);

create table BIBITE (
    nome_prodotto           varchar(25)         not null,
    grandezza_bibita        varchar(10),
    constraint PK_BIBITE primary key (grandezza_bibita),
    constraint FK_BIBITE foreign key (nome_prodotto) references PRODOTTO(nome_prodotto)
);

create table DOLCI(
    nome_prodotto           varchar(25)         not null,
    constraint  PK_DOLCI primary key (nome_prodotto),
    constraint FK_DOLCI foreign key(nome_prodotto) references PRODOTTO(nome_prodotto)
);

create table EXTRA (
    nome_prodotto           varchar(25)         not null,
    grandezza_extra         varchar(10),
    constraint PK_EXTRA primary key (grandezza_extra),
    constraint FK_EXTRA foreign key (nome_prodotto) references PRODOTTO(nome_prodotto)
);

create table MENU_STANDARD (
    codice_menu             number(3)              primary key,
    tipo_menu               varchar(30)         not null,
    prezzo                  number(3,2)              not null
);

create table ORDINE_PRODOTTO (
    numero_ordine                  number(3)       not null,
    nome_prodotto                  varchar(25)  not null,
    constraint PK_ORDINE_PRODOTTO  primary key (numero_ordine, nome_prodotto),
    constraint FK1_Ordine          foreign key (numero_ordine) references ORDINE(numero_ordine),
    constraint FK1_Prodotto        foreign key (nome_prodotto) references PRODOTTO(nome_prodotto) 
);

create table ORDINE_MENU (
    numero_ordine               number(3)          not null,
    codice_menu                 number(3)          not null,
    constraint PK_ORDINE_MENU   primary key (numero_ordine, codice_menu),
    constraint FK2_Ordine       foreign key (numero_ordine) references ORDINE(numero_ordine),
    constraint FK_MENU_STANDARD foreign key (codice_menu) references MENU_STANDARD(codice_menu)
);

create table OFFERTE (
    codice_offerta          number(3)              primary key,
    sede                    varchar(15)         not null,
    durata                  varchar(15)         not null,
    email                   varchar(30)         not null,
    constraint FK_Offerta   foreign key (email) references CLIENTE_ISCRITTO(email)          
);

create table OFFERTE_MENU (
    codice_offerta          number(3)             not null,
    codice_menu             number(3)             not null,
    constraint PK_OFFERTE_MENU primary key (codice_offerta, codice_menu),
    constraint FK1_Offerta foreign key (codice_offerta) references OFFERTE(codice_offerta),
    constraint FK1_MENU_STANDARD foreign key (codice_menu) references MENU_STANDARD(codice_menu)
);

create table PRODOTTO_MENU (
    nome_prodotto           varchar(25)       not null,
    codice_menu             number(3)            not null,
    constraint PK_PRODOTTO_MENU primary key (nome_prodotto, codice_menu),
    constraint FK2_Prodotto foreign key (nome_prodotto) references PRODOTTO(nome_prodotto),
    constraint FK2_MENU_STANDARD foreign key (codice_menu) references MENU_STANDARD(codice_menu)
);

create table ALLERGENI (
    nome_allergene         varchar(15)              primary key,
    nome_prodotto           varchar(25)       not null,
    constraint FK_ALLERGENI foreign key (nome_prodotto) references PRODOTTO(nome_prodotto) 
);

create table FORNITORE (
    partita_iva             number(11)              primary key,
    email_fornitore         varchar(25)         not null,
    ragione_sociale         varchar(20)         not null,
    num_telefono            number(10),
    via                     varchar(30)         not null,
    citta                   varchar(15)         not null,
    cap                     number(5)
);

create table MERCE (
    cod_merce               number(3)              primary key,
    giacenza                number(3)              not null,
    scorta_min              number(3)              not null,
    scorta_max              number(3)              not null,
    prezzo_unitario         number(3,2)              not null,
    costo_acquisto          number(4,2)              not null,
    categoria_merce         varchar(20)         not null,
    partita_iva             number(11)              not null,
    constraint FK_MERCE foreign key (partita_iva) references FORNITORE(partita_iva)
);

create table ORDINE_RIFORNIMENTO (
    cod_ordine_rif          number(3)              primary key,
    quantita_prodotto       number(3)              not null,
    cod_prod_magazzino      number(3)            not null,
    constraint FK_ORDINE_RIF foreign key (cod_prod_magazzino) references MAGAZZINO(cod_prod_magazzino)
);

create table MERCE_ORDINE_RIF (
    costo_tot_merce         number(4,2)              not null,
    cod_merce               number(3)              not null,
    cod_ordine_rif          number(3)              not null,
    constraint PK_MERCE_ORDINE_RIF primary key (cod_merce, cod_ordine_rif),
    constraint FK1_MERCE foreign key (cod_merce) references MERCE(cod_merce),
    constraint FK1_ORDINE_RIF foreign key (cod_ordine_rif) references ORDINE_RIFORNIMENTO(cod_ordine_rif)
);

create table FATTURA (
    codice_fattura          number(7)              primary key,
    data_rilascio           date                not null,
    totale_fattura          number(4,2)              not null,
    cod_ordine_rif          number(3)              not null,
    constraint FK_FATTURA foreign key (cod_ordine_rif) references ORDINE_RIFORNIMENTO(cod_ordine_rif)
);

