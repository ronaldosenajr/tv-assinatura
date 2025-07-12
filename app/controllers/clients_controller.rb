class ClientsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_client, only: [ :show, :edit, :update, :destroy ]

  def index
    @clients = Client.all
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      # Se você quiser retornar um JSON, descomente a linha abaixo
      # render json: @client, status: :created
      # Pode redirecionar para a página de exibição do cliente
      redirect_to @client
    else
      render json: @client.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      # Se você quiser retornar um JSON, descomente a linha abaixo
      # render json: @client, status: :created
      # Pode redirecionar para a página de exibição do cliente
      redirect_to @client
    else
      render json: @client.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    # Se você quiser retornar um JSON, descomente a linha abaixo
    # render json: @client, status: :created
    # Pode redirecionar para a página de exibição do cliente
    redirect_to clients_path
  end

private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.expect(client: [ :name, :age ])
  end
end
