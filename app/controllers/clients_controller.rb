class ClientsController < ApplicationController
  # permite acesso nao autenticado mas somente para testes, tem que ser criado um sistema de autenticação
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access
  before_action :set_client, only: [ :show, :edit, :update, :destroy ]

  def index
    @clients = Client.all
    render json: @clients
  end

  def show
    render json: @client
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      # Se você quiser retornar um JSON, descomente a linha abaixo
      render json: @client, status: :created
      # Pode redirecionar para a página de exibição do cliente
      # redirect_to @client
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      # Se você quiser retornar um JSON, descomente a linha abaixo
      render json: @client, status: :created
      # Pode redirecionar para a página de exibição do cliente
      # redirect_to @client
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    # Se você quiser retornar um JSON, descomente a linha abaixo
    render json: @client, status: :created
    # Pode redirecionar para a página de exibição do cliente
    # redirect_to clients_path
  end

private

  def set_client
    @client = Client.find_by(id: params[:id])
    if @client.nil?
      render json: { error: "Client not found" }, status: :not_found
    end
  end

  def client_params
    params.expect(client: [ :name, :age ])
  end
end
