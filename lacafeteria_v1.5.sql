-- Tornam o banco funcional-----------------------------------------------------------------------------------------------------------------------------
drop database if exists cafeteria;
create database if not exists cafeteria;
use cafeteria;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a tabela dos clientes --------------------------------------------------------------------------------------------------------------------------
drop table if exists cliente;
create table if not exists cliente(
id_cli_cpf varchar(11) primary key,
cli_nome nvarchar(15) not null,
cli_sobrenome nvarchar(30) not null,
cli_dtNasc date
);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a tabela dos pedidos ---------------------------------------------------------------------------------------------------------------------------
drop table if exists pedido;
create table if not exists pedido(
id_pedido int primary key,
ped_data date default (date(now())),
ped_valortotal decimal(5,2));
alter table pedido add column ped_clientefk varchar(11);
alter table pedido add constraint clientefk foreign key (ped_clientefk) references cliente (id_cli_cpf);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- cria a tabela que guarda os itens do pedido ---------------------------------------------------------------------------------------------------------
drop table if exists itempedido;
create table if not exists itemPedido(
id_item int primary key auto_increment,
item_qtdprod int,
item_prodfk int,
item_pedfk int);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a tabela que guarda o estoque de ingredientes --------------------------------------------------------------------------------------------------
drop table if exists ingrediente;
create table if not exists ingrediente(
id_ingrediente int primary key auto_increment,
ingred_nome varchar(15),
ingred_qtde int,
ingred_precounit decimal (4,2));
-- Insere os ingredientes na tabela --------------------------------------------------------------------------------------------------------------------
insert into ingrediente values
(default,"queijo",200, 1),(default,"presunto",150,0.50),
(default,"bacon",70,2),(default,"ovo",50,0.50),
(default,"pão",100,0.25),(default,"hamburger",100,4),
(default,"Ham. de Picanha",50,6),(default,"Alface",50,0.60),
(default,"Tomate",40,0.70),(default,"Cebola",30,0.40);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a tabela que guarda os lanches -----------------------------------------------------------------------------------------------------------------
drop table if exists produto;
create table if not exists produto(
id_produto int primary key auto_increment,
prod_nome varchar(15) not null,
prod_precounit decimal (5,2),
prod_qtdeTotal int);
-- Insere na tabela os lanches -------------------------------------------------------------------------------------------------------------------------
insert into produto  (prod_nome, prod_qtdetotal, prod_precounit) values ("Bauru",0, null),("X-Picanha",0,null),("X-Burger",0,null),("X-Bacon",0,null),("Refrigerante",0,5),("Milk Shake",0,10),("Bebida Gratis",0,0);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Faz o relacionamento entre lanche e preço -----------------------------------------------------------------------------------------------------------
drop table if exists itemlanche;
create table if not exists itemLanche(
id_itemLanche int primary key auto_increment,
item_qtdeingrediente int,
item_produtofk int, 
item_ingredfk int);
alter table itemLanche add constraint itemprodutofk foreign key (item_produtofk) references produto (id_produto);
alter table itemLanche add constraint itemingredfk foreign key (item_ingredfk) references ingrediente(id_ingrediente);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- montando o lanche do Bauru --------------------------------------------------------------------------------------------------------------------------
insert into itemLanche values(default,2,1,1),(default,2,1,2),(default,1,1,5),(default,1,1,8),(default,2,1,9);
-- insert do lanche x-picanha --------------------------------------------------------------------------------------------------------------------------
insert into itemLanche values(default,2,2,1),(default,2,2,7),(default,1,2,5),(default,1,2,8),(default,2,2,9);
-- insert do lanche X-burguer --------------------------------------------------------------------------------------------------------------------------
insert into itemLanche values(default,3,3,1),(default,2,3,6),(default,1,3,5),(default,1,3,10),(default,2,3,4);
-- insert do lanche X-Bacon ----------------------------------------------------------------------------------------------------------------------------
insert into itemLanche values(default,3,4,1),(default,2,4,6),(default,1,4,5),(default,2,4,10),(default,1,4,8);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Calcula o preço dos produtos baseado no valor de cada ingrediente
update produto SET prod_precounit =(SELECT sum((item.item_qtdeingrediente * ingred.ingred_precounit)) as 'Valor do ingrediente no lanche'from itemlanche as item join ingrediente as ingred on ingred.id_ingrediente = item.item_ingredfk where item_produtofk = 1) where id_produto = 1;
update produto SET prod_precounit =(SELECT sum((item.item_qtdeingrediente * ingred.ingred_precounit)) as 'Valor do ingrediente no lanche'from itemlanche as item join ingrediente as ingred on ingred.id_ingrediente = item.item_ingredfk where item_produtofk = 2) where id_produto = 2;
update produto SET prod_precounit =(SELECT sum((item.item_qtdeingrediente * ingred.ingred_precounit)) as 'Valor do ingrediente no lanche'from itemlanche as item join ingrediente as ingred on ingred.id_ingrediente = item.item_ingredfk where item_produtofk = 3) where id_produto = 3;
update produto SET prod_precounit =(SELECT sum((item.item_qtdeingrediente * ingred.ingred_precounit)) as 'Valor do ingrediente no lanche'from itemlanche as item join ingrediente as ingred on ingred.id_ingrediente = item.item_ingredfk where item_produtofk = 4) where id_produto = 4;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a tablela que armazena os ingredientes em baixa ------------------------------------------------------------------------------------------------
drop table if exists compra;
create table if not exists compra(
c_id int auto_increment primary key,
c_id_ingrediente int
);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a tabela que armazena as notas fiscais ---------------------------------------------------------------------------------------------------------
drop table if exists notaFiscal;
create table if not exists notaFiscal(
n_id int auto_increment primary key,
n_id_cli_fk varchar(11),
n_nome varchar(15),
n_sobrenome varchar(30),
n_dt date,
n_total decimal(5,2),
n_s_desc decimal(5,2),
n_desc int 
);
alter table notafiscal add constraint n_id_cli_fk foreign key (n_id_cli_fk) references cliente (id_cli_cpf);
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- procedure para baixar a qtde dos ingredientes  na tabela igrediente conforme faz o lanche escolhido--------------------------------------------------
delimiter //
drop procedure if exists baixaIngrediente //
create procedure baixaIngrediente(Lanche int)
begin
	case
		when Lanche = 1 then
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=1;
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=2;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=5;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=8;
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=9;
	
		when Lanche =2 then
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=1;
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=7;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=5;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=8;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=9;
	
		when Lanche = 3 then
			update ingrediente set ingred_qtde=ingred_qtde-3 where id_ingrediente=1;
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=6;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=5;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=10;
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=4;
	
		when Lanche = 4 then
			update ingrediente set ingred_qtde=ingred_qtde-3 where id_ingrediente=1;
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=6;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=5;
			update ingrediente set ingred_qtde=ingred_qtde-2 where id_ingrediente=10;
			update ingrediente set ingred_qtde=ingred_qtde-1 where id_ingrediente=8;
			update ingrediente set ingred_qtde=ingred_qtde-3 where id_ingrediente=3;
        end case;
	end//
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- procedure para fazer  lanche --> 1 - Bauru - 2- X-Picanha | 3 - X-Burger | 4 - X-Bacon --------------------------------------------------------------
DELIMITER //
drop procedure if exists FazerLanche; //
create procedure FazerLanche(Lanche int)
BEGIN
	case
		when Lanche=1 then
			insert into itemLanche values(default,2,1,1),
			(default,2,1,2),(default,1,1,5),(default,1,1,8),
			(default,2,1,9);
        
			-- baixar a qtde dos ingredientes de Bauru
			call baixaIngrediente(1); 
        
			-- acrescenta 1 unidade na qtde total de Bauru na tabela produto
			update produto set prod_qtdeTotal = produto.prod_qtdeTotal + 1 where id_produto=1;
		
        
		when Lanche = 2 then
			insert into itemLanche values(default,2,2,1),
			(default,2,2,7),(default,1,2,5),(default,1,2,8),
			(default,2,2,9);
        
			-- baixar a qtde dos ingredientes de X-Picanha na tabela ingrediente
			call baixaIngrediente(2); 
        
			-- acrescenta 1 unidade na qtde total de X-Picanha na tabela produto
			update produto set prod_qtdeTotal = produto.prod_qtdeTotal + 1 where id_produto=2;
	
			when Lanche = 3 then
			insert into itemLanche values(default,3,3,1),
			(default,2,3,6),(default,1,3,5),(default,1,3,10),
			(default,2,3,4);
        
			-- baixar a qtde dos ingredientes de X-Burger na tabela ingrediente
			call baixaIngrediente(3); 
        
			-- acrescenta 1 unidade na qtde total de X-Burger na tabela produto        
			update produto set prod_qtdeTotal = produto.prod_qtdeTotal + 1 where id_produto=3;
	
		when Lanche = 4 then
			insert into itemLanche values(default,3,4,1),
			(default,2,4,6),(default,3,4,3),(default,2,4,10),
			(default,1,4,8);
        
			-- baixar a qtde dos ingredientes de X-Bacon na tabela ingrediente
			call baixaIngrediente(4); 
        
			-- acrescenta 1 unidade na qtde total de X-Bacon na tabela produto
			update produto set prod_qtdeTotal = produto.prod_qtdeTotal + 1 where id_produto=4;
	end case;
end  //
DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a procedure que cadastra cliente ---------------------------------------------------------------------------------------------------------------
DELIMITER //
drop procedure if exists cadastrarCliente //
create procedure cadastrarCliente(cpf varchar(11), nome varchar(15), sobrenome varchar(30), dtNasc date)
main:begin
	declare valido int;
    declare verificacao int;
    declare n1,n2,n3,n4,n5,n6,n7,n8,n9,n10 int;
    
    set n1 = mid(cpf,1,1); -- Primeiro numero
    set n2 = mid(cpf,2,1); -- Segundo numero
    set n3 = mid(cpf,3,1); -- Terceiro numero
    set n4 = mid(cpf,4,1); -- Quarto numero
    set n5 = mid(cpf,5,1); -- Quinto numero
    set n6 = mid(cpf,6,1); -- Sexto numero
    set n7 = mid(cpf,7,1); -- Setimo numero
    set n8 = mid(cpf,8,1); -- Oitavo numero
    set n9 = mid(cpf,9,1); -- Nono numero
    set n10 = mid(cpf,10,1); -- Decimo numero
    
	-- Lógica:
	-- https://dicasdeprogramacao.com.br/algoritmo-para-validar-cpf/
    
    if (((n1*10 + n2*9 + n3*8 + n4*7 + n5*6 + n6*5 + n7*4 + n8*3 + n9*2)*10) % 11 = n10) then 
		set valido = 1;
    end if;
    
    if(valido = 1 ) then
		insert into cliente (id_cli_cpf, cli_nome, cli_sobrenome, cli_dtNasc) values(cpf,nome,sobrenome, dtNasc);
        select 'Cliente cadastrado com sucesso' as Sucesso;
    else 
		select 'CPF invalido' as Atenção;
	end if;

end  //
DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a procedure para busca de cliente --------------------------------------------------------------------------------------------------------------
DELIMITER //
drop procedure if exists procuraCliente //
create procedure procuraCliente(cpf varchar(11))
main:begin
	declare valido int;
    declare verificacao int;
    declare n1,n2,n3,n4,n5,n6,n7,n8,n9,n10 int;
    
    set n1 = mid(cpf,1,1); -- Primeiro numero
    set n2 = mid(cpf,2,1); -- Segundo numero
    set n3 = mid(cpf,3,1); -- Terceiro numero
    set n4 = mid(cpf,4,1); -- Quarto numero
    set n5 = mid(cpf,5,1); -- Quinto numero
    set n6 = mid(cpf,6,1); -- Sexto numero
    set n7 = mid(cpf,7,1); -- Setimo numero
    set n8 = mid(cpf,8,1); -- Oitavo numero
    set n9 = mid(cpf,9,1); -- Nono numero
    set n10 = mid(cpf,10,1); -- Decimo numero
    
	-- Lógica:
	-- https://dicasdeprogramacao.com.br/algoritmo-para-validar-cpf/
	
    if (((n1*10 + n2*9 + n3*8 + n4*7 + n5*6 + n6*5 + n7*4 + n8*3 + n9*2)*10) % 11 = n10) then 
		set valido = 1;
    end if;
    
    if(valido = 1 ) then
		select * from cliente where id_cli_cpf  = cpf;
        else 
		select 'CPF invalido' as Atenção;
	end if;

end  //
DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a view que visualiza a quantidade de cada ingrediente no estoque -------------------------------------------------------------------------------
drop view if exists estoque;
CREATE VIEW estoque AS SELECT ingred_nome as 'Produto',ingred_qtde as 'Quantidade' FROM ingrediente;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a view que visualiza os produtos com baixo estoque ---------------------------------------------------------------------------------------------
drop view if exists EmFalta;
CREATE VIEW EmFalta AS select c_id as 'Id da compra', ingred_nome as 'Produto' from compra join ingrediente on id_ingrediente = c_id_ingrediente;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a procedure que anota os produtos do cliente ---------------------------------------------------------------------------------------------------
DELIMITER //
drop procedure if exists anotaItensPedido //
create procedure anotaItensPedido(idProd int, qtdProd int, idPed int)
main:begin
	insert into itempedido values (default, qtdProd, idProd, idPed);
end  //
DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a procedure que registra o pedido do cliente ---------------------------------------------------------------------------------------------------
DELIMITER //
drop procedure if exists registraPedido //
create procedure registraPedido(id int, data date, cpf varchar(11))
main:begin
	declare vt decimal(5,2);
    set vt = (select sum(item.item_qtdprod * prod.prod_precounit) from itempedido as item join produto as prod on item.item_prodfk = prod.id_produto where item_pedfk = 1);
	insert into pedido values (id,data,vt,cpf);
    
    if(vt > 20)then
		insert into itempedido values(default, 1,7,id);
    end if;
end  //
DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a procedure que altera a quantidade de determinado ingrediente no estoque ----------------------------------------------------------------------
DELIMITER //
drop procedure if exists altIngrediente //
create procedure altIngrediente(id int, qtd int)
main:begin  
    
if((select id_ingrediente from ingrediente where id_ingrediente=id) = id)then
	UPDATE ingrediente SET ingred_qtde = qtd where id_ingrediente=id;
else
	select 'id invalido';
end if;

end  //
DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a TRIGGER que é ativada quando o produto está abaixo de 50 unidades no estoque -----------------------------------------------------------------
DELIMITER //
drop trigger if exists TRG_Baixo_Estoque ; //
CREATE TRIGGER TRG_Baixo_Estoque AFTER UPDATE ON ingrediente
FOR EACH ROW
BEGIN
	declare id int;
    set id = old.id_ingrediente;
	if (new.ingred_qtde < 50)then
		insert into compra values (default, id);
	end if;
END //
DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria a PROCEDURE que registra a nota fiscal do cliente mediante seu pedido --------------------------------------------------------------------------
DELIMITER //
drop procedure if exists calcNota //
create procedure calcNota(id varchar(15))
main:begin
	declare valido int;
    declare verificacao int;
    declare n1,n2,n3,n4,n5,n6,n7,n8,n9,n10 int;
	declare desconto, aniversario, crianca, homem, mulher int;
    declare nome varchar(15);
    declare sobrenome varchar(30);
    declare dtNasc date;
    declare dtPedido date;
    declare totalPre,totalPos decimal (5,2);
    declare mes,dia, mesN, diaN int;
    
    set n1 = mid(id,1,1); -- Primeiro numero
    set n2 = mid(id,2,1); -- Segundo numero
    set n3 = mid(id,3,1); -- Terceiro numero
    set n4 = mid(id,4,1); -- Quarto numero
    set n5 = mid(id,5,1); -- Quinto numero
    set n6 = mid(id,6,1); -- Sexto numero
    set n7 = mid(id,7,1); -- Setimo numero
    set n8 = mid(id,8,1); -- Oitavo numero
    set n9 = mid(id,9,1); -- Nono numero
    set n10 = mid(id,10,1); -- Decimo numero
    
	-- Lógica:
	-- https://dicasdeprogramacao.com.br/algoritmo-para-validar-cpf/
	
    
    if (((n1*10 + n2*9 + n3*8 + n4*7 + n5*6 + n6*5 + n7*4 + n8*3 + n9*2)*10) % 11 = n10) then 
		set valido = 1;
    end if;
    
    if((select id_cli_cpf from cliente where id_cli_cpf = id) = id)then
		set valido = 1;
	else
		set valido = 0;
    end if;
    
    if(valido = 1 ) then
    
    set nome = (select cli_nome from cliente where id_cli_cpf = id);
    set sobrenome = (select cli_sobrenome from cliente where id_cli_cpf = id);
    set dtNasc = (select cli_dtNasc from cliente where id_cli_cpf = id); 
    set mesN = (select month(cli_dtNasc) from cliente where id_cli_cpf = id );
    set diaN = (select day(cli_dtNasc) from cliente where id_cli_cpf = id);
    set dtPedido = date((select ped.ped_data from pedido as ped join cliente as cli on cli.id_cli_cpf = id)); 
    set totalPre = (select ped.ped_valortotal from pedido as ped join cliente as cli on cli.id_cli_cpf = id);
    set dia = (select day(ped.ped_data) from pedido as ped join cliente as cli on cli.id_cli_cpf = id);
    set mes = (select month(ped.ped_data) from pedido as ped join cliente as cli on cli.id_cli_cpf = id);
    
	if(mesN = mes and diaN = dia)then
			set aniversario = 15;
		else
			set aniversario = 0;
        end if;
    if (mes = 10 and dia = 12) then
			set crianca = 5;
        else
			set crianca = 0;
        end if;
    if (mes = 7 and dia = 15) then
			set homem = 5;
		else
			set homem = 0;
        end if;
    if (mes = 8 and dia = 3 ) then
		set mulher =  5;
    else 
        set mulher =  0;
    end if;
    
    set desconto = aniversario + crianca + homem + mulher;
    
    set totalPos = (totalPre - ((desconto / 100)*totalPre));
    
    insert into notafiscal values (default, id, nome, sobrenome, dtPedido, totalPos, totalPre, desconto);
    truncate table pedido;
	truncate table itempedido;
    
     else 
		select 'CPF invalido' as Atenção;
	end if;
END //
DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- SESSÃO DE TESTES ------------------------------------------------------------------------------------------------------------------------------------

-- Registre o cliente ----------------------------------------------------------------------------------------------------------------------------------
call cadastrarCliente(42942544830, 'cesar', 'august', 20000416); -- (CPF, NOME, SOBRENOME, DATA)
-- Procura cliente no banco de dados -------------------------------------------------------------------------------------------------------------------
call procuraCliente(42942544830); -- (CPF)
-- Veirifica estoque de ingredientes por meio de VIEW --------------------------------------------------------------------------------------------------
select * from estoque;
-- Verifica no banco dedados os ingredientes que stão em baixa no estoque por meio de VIEW, jogados na tabela por meio de TRIGGER ----------------------
select * from EmFalta;
-- Altera a quantidade de ingrediente no estoque -------------------------------------------------------------------------------------------------------
call altIngrediente(3, 49); -- (ID INGREDIENTE, QUANTIDADE)
-- Montar um lanche removendo do estoque os ingredientes -----------------------------------------------------------------------------------------------
call fazerLanche(4); -- (ID LANCHE) // 1- bauru/ 2- x-picanha/3- x-burguer/4- x-bacon //
-- Anota os produtos que serão inseridos no pedido do cliente ------------------------------------------------------------------------------------------
call anotaItensPedido(4,2,1); -- (ID PRODUTO, QUANTIDADE, ID PEDIDO)
-- Registra o pedido do cliente ------------------------------------------------------------------------------------------------------------------------
call registraPedido(1, 20190915, 42942544830); -- (ID PEDIDO, DATA, CPF)
-- Mostra os valores inseridos na tabela de pedido -----------------------------------------------------------------------------------------------------
select * from pedido;
-- Mostra os itens pagos e ocasionalmente o brinde atribuido -------------------------------------------------------------------------------------------
select * from itempedido;
-- Cria a nota fiscal do cliente por meio do cpf -------------------------------------------------------------------------------------------------------
call calcNota (42942544830); -- (CPF)
-- -----------------------------------------------------------------------------------------------------------------------------------------------------