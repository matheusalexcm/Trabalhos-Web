<%@page import="java.util.List"%>
<%@page import="br.grupointegrado.ads.gerenciadorDeProdutos.utils.Formatter"%>
<%@page import="br.grupointegrado.ads.gerenciadorDeProdutos.modelos.Produto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Produto produto;
    if (request.getAttribute("produto") != null) {
        produto = (Produto) request.getAttribute("produto");
    } else {
        produto = new Produto();
    }

    Object mensagemErro = request.getAttribute("mensagem-erro");
    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <title>Gerenciamento de Produtos</title>

        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
        <script src="/gerenciador/js/validations.js"></script>

        <script>
            function validaCadastro(event) {
                //event.preventDefault();

                //var nome = document.form-produto.produto-nome.value;

                var nomeInput = document['form-produto']['produto-nome'];
                var precoInput = document['form-produto']['produto-preco'];
                var quantidadeInput = document['form-produto']['produto-quantidade'];
                var validadeInput = document['form-produto']['produto-validade'];

                var formValido = true;

                if (!validaString(nomeInput.value, 5)) {
                    formValido = false;
                    nomeInput.classList.add('is-invalid');
                    nomeInput.classList.remove('is-valid');
                } else {
                    nomeInput.classList.remove('is-invalid');
                    nomeInput.classList.add('is-valid');
                }

                if (!validaNumber(precoInput.value, 0.01, Number.MAX_VALUE)) {
                    formValido = false;
                    precoInput.classList.add('is-invalid');
                    precoInput.classList.remove('is-valid');
                } else {
                    precoInput.classList.remove('is-invalid');
                    precoInput.classList.add('is-valid');
                }

                if (!validaNumber(quantidadeInput.value, 0, Number.MAX_VALUE)) {
                    formValido = false;
                    quantidadeInput.classList.add('is-invalid');
                    quantidadeInput.classList.remove('is-valid');
                } else {
                    quantidadeInput.classList.remove('is-invalid');
                    quantidadeInput.classList.add('is-valid');
                }

                var dataMinima = moment().startOf('day');
                var dataMaxima = moment().startOf('day').add('year', 10);
                if (!validaData(validadeInput.value, dataMinima, dataMaxima)) {
                    formValido = false;
                    validadeInput.classList.add('is-invalid');
                    validadeInput.classList.remove('is-valid');
                } else {
                    validadeInput.classList.remove('is-invalid');
                    validadeInput.classList.add('is-valid');
                }

                return formValido;
            }
            
            function excluirProduto(produtoId){
                var resultado = confirm("Deseja excluir o produto " + produtoId + " ?");
                if (resultado) {
                    window.location = "produtos?excluirProduto=" + produtoId;
                }
            }
        </script>
    </head>

    <body>
        <div class="container">
            <h1>Gerenciamento de Produtos</h1>

            <section>
                <h2>Cadastro de produtos</h2>

                <%
                    if (mensagemErro != null) {
                %>
                <div class="alert alert-danger" role="alert">
                    <%= mensagemErro%>
                </div>

                <%
                    }
                %>

                <form name="form-produto" method="POST" onsubmit="return validaCadastro();">
                    <input type="hidden" name="produto-id" value="<%= produto.getId() %>" />
                    
                    <div class="form-group">
                        <label for="produto-nome">Nome</label>
                        <input type="text" class="form-control" 
                               id="produto-nome" name="produto-nome" value="<%= produto.getNome()%>"/>
                        <div class="invalid-feedback">
                            Informe o nome com o mínimo de 5 caracteres.                            
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="produto-descricao">Descrição</label>
                        <textarea class="form-control" id="produto-descricao" 
                                  name="produto-descricao" ><%= produto.getDescricao()%></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group col">
                            <label for="produto-preco">Preço</label>
                            <input type="number" class="form-control" id="produto-preco" 
                                   name="produto-preco" step="0.01" value="<%= produto.getPreco()%>"/>
                            <div class="invalid-feedback">
                                Informe o preço do produto.                            
                            </div>
                        </div>
                        <div class="form-group col">
                            <label for="produto-quantidade">Quantidade</label>
                            <input type="number" class="form-control" id="produto-quantidade" 
                                   name="produto-quantidade" step="1" value="<%= produto.getQuantidade()%>"/>
                            <div class="invalid-feedback">
                                Informe um valor positivo para a quantidade.                            
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="produto-validade">Data de validade</label>
                            <input type="date" class="form-control" id="produto-validade" 
                                   name="produto-validade" 
                                   value="<%= produto.getDataValidadeString()%>"/>
                            <div class="invalid-feedback">
                                Informe uma data igual ou maior a atual.                            
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Salvar</button>
                </form>
            </section>

            <br><br>

            <section>
                <h2>Listagem de Produtos</h2>
                
                <form class="mb-3">
                    <div class="input-group">
                        <input type="text" name="buscar-produtos" class="form-control" 
                               placeholder="Buscar por nome ou descrição...">
                        <div class="input-group-append">
                            <button class="btn btn-outline-primary">Buscar</button>
                        </div>
                    </div>  
                </form>
                
                <table class="table table-sm table-striped">
                    <tr>
                        <th>ID</th>
                        <th>Produtos</th>
                        <th>Descrição</th>
                        <th>Quantidade</th>
                        <th>Preço</th>
                        <th>Validade</th>
                        <th>Ações</th>
                    </tr>

                    <%
                        for (Produto p : produtos) {
                    %>

                    <tr>
                        <td><%= p.getId()%></td>
                        <td><%= p.getNome()%></td>
                        <td><%= p.getDescricao()%></td>
                        <td><%= p.getQuantidade()%></td>
                        <td><%= p.getPreco()%></td>
                        <td><%= Formatter.dataParaString(p.getDataValidade())%></td>
                        <td>
                            <div class="btn-group btn-group-sm" role="group">
                                <a href="?produto=<%= p.getId()%>" class="btn">Editar</a>
                                <button onclick="excluirProduto(<%= p.getId()%>)" type="button" class="btn btn-danger">Excluir</button>
                            </div>
                        </td>
                    </tr>

                    <%
                        }
                    %>
                </table>
            </section>
        </div>

        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>    
    </body>
</html>
