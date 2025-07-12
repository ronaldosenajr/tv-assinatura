class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      # Se você quiser retornar um JSON, descomente a linha abaixo
      #render json: @client, status: :created
      # Pode redirecionar para a página de exibição do cliente
      redirect_to @client
    else
      render json: @client.errors.full_messages, status: :unprocessable_entity
    end
  end

private

  def client_params
    params.expect(client: [:name, :age])
  end
end
