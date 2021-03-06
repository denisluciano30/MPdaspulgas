create type lista_telefones as varray(20) of varchar(2000);
/
create type endereco as object(estado char(100), bairro char(100), numero integer, cidade char(30), cep char(30));
/
create type lista_enderecos as TABLE of endereco;
/
create type categoria as object (titulo char(30), prazo_max integer, tipo char(30));
/
create type usuario as object (email char (30), senha char(20), cpf char (11), nome char(100), apelido char(10), enderecos lista_enderecos, telefones lista_telefones);
/
create type anuncio as object (titulo char (30),descricao char (200),foto varchar(2000), data_ date, valor_inicial float,e_de ref usuario, possui_c ref categoria, disponivel number(1,0)) not final;
/
create type negociacao under anuncio (tipo integer, tempo_devolucao integer);
/
create type leilao under anuncio (data_abertura date, data_fim date);
/
/* create type compra as object (e_de ref usuario, do_anuncio ref anuncio, data_ date, precofim float); */
/
create type compra_negoc as object (e_de ref usuario, do_negoc ref negociacao, data_ date, precofim float);
/
create type compra_leilao as object (e_de ref usuario, do_leilao ref leilao, data_ date, precofim float);
/
create type lance as object (e_de ref usuario, do_leilao ref leilao, data_ date, valor float);
/
create table categorias of categoria;
/
create table usuarios of usuario nested table enderecos store as endereco_usuario;
/
create table anuncios of anuncio;
/
create table negociacoes of negociacao;
/
create table leiloes of leilao;
/
/*create table compras of compra;*/
/
create table compras_n of compra_negoc;
/
create table compras_l of compra_leilao;
/
create table lances of lance;
/


/* categorias*/
/* create type categoria as object (titulo char(30), prazo_max integer, tipo char(30));*/

insert into categorias values ('Automoveis', 30, 'Produto');
/
insert into categorias values ('Eletrodomesticos', 30, 'Produto');
/
insert into categorias values ('Eletronicos', 30, 'Produto');
/
insert into categorias values ('Livraria',30, 'Produto');
/
insert into categorias values ('Servicos',30, 'Serviço');
/
insert into categorias values ('Pecuaria',30, 'Produto');
/
insert into categorias values ('Outros',30, 'Outros');
/

/* usuarios */
/* create type usuario as object (email char (30), cpf char (11), nome char(100), apelido char(10), enderecos lista_enderecos, telefones lista_telefones); */

insert into usuarios values ('astolfo@gmail.com','senha','11922548213','Astolfo Filho','Astolfinho', lista_enderecos(endereco('mg','centro',22,'vicosa','39021910')),lista_telefones('3891-2233','3901-2211'));
/
insert into usuarios values ('maju@ufv.br','insirasenha','19329412039','Maria Julia','Maju', lista_enderecos(endereco('mg','centro',33,'vicosa','39012341')),lista_telefones('3912-3321'));
/
/* negociacoes */
/* create type anuncio as object (titulo char (30),descricao char (200),data_ date, valor_inicial float,e_de ref usuario, possui_c ref categoria, disponivel number(1,0)) not final; */
/* create type negociacao under anuncio (tipo integer, tempo_devolucao integer); */
/* categorias: 0-venda simples, 1- troca, 2-doacao, 3- emprestimo*/
/
insert into negociacoes values('Girassol','Mudas de Girassol para jardim',date '2019-06-14' ,30, (select ref(u) from usuarios u where u.email='astolfo@gmail.com'),(select ref(c) from categorias c where c.tipo='Limpeza'),1,0,0);
/
insert into negociacoes values ('Motor','Motor para Uno quadrado',date '2019-05-14',30,(select ref(u) from usuarios u where u.email = 'maju@ufv.br'),(select ref (c) from  categorias c where tipo = 'Mecanica'),0,1,0);
/
insert into negociacoes values ('Faxina','Faxina em apartamento', date '2019-05-14',30,(select ref(u) from usuarios u where u.email = 'maju@ufv.br'),(select ref(c) from categorias c where tipo = 'Limpeza'),0,0,0);
/
/* leiloes */
/* create type anuncio as object (titulo char (30),descricao char (200),data_ date, valor_inicial float,e_de ref usuario, possui_c ref categoria, disponivel number(1,0)) not final; */
/* create type leilao under anuncio (data_abertura date, data_fim date); */
/
insert into leiloes values ('Boizao','Boi de 1T',date '2019-06-14', 10000, (select ref(u) from usuarios u where u.email = 'astolfo@gmail.com'),(select ref(c) from categorias c where c.tipo = 'Pecuaria'),1,date '2019-06-20',date '2019-06-30');

/* compras */
/* create type compra as object (e_de ref usuario, do_anuncio ref anuncio, data_ date, precofim float); */

/
insert into compras values ((select ref(u) from usuarios u where u.email = 'astolfo@gmail.com'), (select ref(an) from anuncios an where an.titulo = 'Faxina'), date '2019-05-15', 30);
/

/* lances */
/* create type lance as object (e_de ref usuario, do_leilao ref leilao, data_ date, valor float); */
/
insert into lances values ((select ref(u) from usuarios u where u.email = 'maju@ufv.br'),(select ref(le) from leiloes le where le.titulo ='Boizao'),date '2019-06-15', 11000, 1 );
/

/*
-- Dados para conectar ao banco de dados hospedado na amazon database(Pode usar ferramenta sql developer)
-- nome do usuario: denisluciano30
-- senha: 12345678
-- nome host: mpdaspulgasdb.cjkzd5ocipkp.sa-east-1.rds.amazonaws.com
-- porta: 1521
-- Marca opão nome serviço e digita: orcl
*/






/*
--Para alterar tipo(estrutura da tabela)
ALTER TYPE lance ADD ATTRIBUTE (id integer) CASCADE;
ALTER TYPE compra DROP ATTRIBUTE id cascade;
*/





/*
Para fazer auto increments eno oracle usando trigger
/
ALTER TABLE nometabela
 ADD (
 CONSTRAINT auto_increment_nometabela_pk PRIMARY KEY (id)
 );
/
CREATE SEQUENCE auto_increment_nometabela_seq;
/
CREATE OR REPLACE TRIGGER auto_increment_nometabela_insert
 BEFORE INSERT ON nometabela
 FOR EACH ROW
BEGIN
 SELECT auto_increment_nometabela_seq.nextval
 INTO :new.id
 FROM dual;
END;
/
*/





/* --drop primary key
ALTER TABLE EMP DROP CONSTRAINT emp_name_PK1
 */


/* obs: id de leilao e negociacao esta anuncio*/
ALTER TYPE usuario ADD ATTRIBUTE (id integer) CASCADE;

ALTER TYPE anuncio ADD ATTRIBUTE (id integer) CASCADE;
/*Esse id2 é uma gambiarra. Mas se for criar zero coloca id1*/

-- ALTER TYPE negociacao ADD ATTRIBUTE (id integer) CASCADE;
-- ALTER TYPE leilao ADD ATTRIBUTE (id integer) CASCADE;

ALTER TYPE compra_negoc ADD ATTRIBUTE (id integer) CASCADE;
ALTER TYPE compra_leilao ADD ATTRIBUTE (id integer) CASCADE;
ALTER TYPE lance ADD ATTRIBUTE (id integer) CASCADE;

-- referencia maior lance
ALTER TYPE leilao ADD ATTRIBUTE (maior_lance ref lance) CASCADE;





/
 ALTER TABLE usuarios
 ADD (
 CONSTRAINT auto_increment_usuarios_pk PRIMARY KEY (id)
 );
/
CREATE SEQUENCE auto_increment_usuarios_seq;
/
CREATE OR REPLACE TRIGGER auto_increment_usuarios_insert
 BEFORE INSERT ON usuarios
 FOR EACH ROW
BEGIN
 SELECT auto_increment_usuarios_seq.nextval
 INTO :new.id
 FROM dual;
END;
/
-- id para tabela de negociacao e abaixo para de leiloes
-- /
--  ALTER TABLE negociacoes
--  ADD (
--  CONSTRAINT auto_increment_negoc_pk PRIMARY KEY (id)
--  );
-- /
-- CREATE SEQUENCE auto_increment_negoc_seq;
-- /
-- CREATE OR REPLACE TRIGGER auto_increment_negoc_insert
--  BEFORE INSERT ON negociacoes
--  FOR EACH ROW
-- BEGIN
--  SELECT auto_increment_negociacoes_seq.nextval
--  INTO :new.id
--  FROM dual;
-- END;
-- /
-- /
-- -- id para tabela de leiloes
-- /
--  ALTER TABLE leiloes
--  ADD (
--  CONSTRAINT auto_increment_leiloes_pk PRIMARY KEY (id)
--  );
-- /
-- CREATE SEQUENCE auto_increment_leiloes_seq;
-- /
-- CREATE OR REPLACE TRIGGER auto_increment_leiloes_insert
--  BEFORE INSERT ON leiloes
--  FOR EACH ROW
-- BEGIN
--  SELECT auto_increment_leiloes_seq.nextval
--  INTO :new.id
--  FROM dual;
-- END;
-- /
-- /


/
 ALTER TABLE anuncios
 ADD (
 CONSTRAINT auto_increment_anuncios_pk PRIMARY KEY (id)
 );
/
CREATE SEQUENCE auto_increment_anuncios_seq;
/
/*trigger para incrementar id do anuncio ao inserir leilao*/
CREATE OR REPLACE TRIGGER auto_increment_anuncios_n_insert
 BEFORE INSERT ON negociacoes
 FOR EACH ROW
BEGIN
 SELECT auto_increment_anuncios_seq.nextval
 INTO :new.id
 FROM dual;
END;
/
/
/
/*trigger para incrementar id do anuncio ao inserir leilao*/
CREATE OR REPLACE TRIGGER auto_increment_anuncios_l_insert
 BEFORE INSERT ON leiloes
 FOR EACH ROW
BEGIN
 SELECT auto_increment_anuncios_seq.nextval
 INTO :new.id
 FROM dual;
END;
/
/***********************************/
-- /
--  ALTER TABLE compras
--  ADD (
--  CONSTRAINT auto_increment_compras_pk PRIMARY KEY (id)
--  );
-- /
-- CREATE SEQUENCE auto_increment_compras_seq;
-- /
-- CREATE OR REPLACE TRIGGER auto_increment_compras_insert
--  BEFORE INSERT ON compras
--  FOR EACH ROW
-- BEGIN
--  SELECT auto_increment_compras_seq.nextval
--  INTO :new.id
--  FROM dual;
-- END;
-- /
/
 ALTER TABLE compras_n
 ADD (
 CONSTRAINT auto_increment_compras_n_pk PRIMARY KEY (id)
 );
/
CREATE SEQUENCE auto_increment_compras_n_seq;
/
CREATE OR REPLACE TRIGGER auto_increment_compras_n_insert
 BEFORE INSERT ON compras_n
 FOR EACH ROW
BEGIN
 SELECT auto_increment_compras_n_seq.nextval
 INTO :new.id
 FROM dual;
END;
/
/
 ALTER TABLE compras_l
 ADD (
 CONSTRAINT auto_increment_compras_l_pk PRIMARY KEY (id)
 );
/
CREATE SEQUENCE auto_increment_compras_l_seq;
/
CREATE OR REPLACE TRIGGER auto_increment_compras_l_insert
 BEFORE INSERT ON compras_l
 FOR EACH ROW
BEGIN
 SELECT auto_increment_compras_l_seq.nextval
 INTO :new.id
 FROM dual;
END;
/
--
--
--
/
 ALTER TABLE lances
 ADD (
 CONSTRAINT auto_increment_lances_pk PRIMARY KEY (id)
 );
/
CREATE SEQUENCE auto_increment_lances_seq;
/
CREATE OR REPLACE TRIGGER auto_increment_lances_insert
 BEFORE INSERT ON lances
 FOR EACH ROW
BEGIN
 SELECT auto_increment_lances_seq.nextval
 INTO :new.id
 FROM dual;
END;
/



/***************************************************/
-- drop table compras_l;
-- drop table compras_n;
-- drop table negociacoes;
-- drop table lances;
-- drop table leiloes;
-- drop table anuncios;
-- drop table categorias;
-- drop table anuncios;
-- drop table usuarios;


