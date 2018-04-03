class OfficesController < ApplicationController
  # GET /offices
  def index
    can?(:read, 'offices') do
      @departments = Department.order(code: :asc)
      @divisions = Division.order(code: :asc).page(params[:division_page] || 1)
      @sector_cities = SectorCity.order(code: :asc).page(params[:sectorcity_page] || 1)
      @cities = City.order(code: :asc).page(params[:city_page] || 1)
      @offices = Office.order(code: :asc).page(params[:office_page] || 1)
    end
  end

  # GET /offices/new
  def new
    can?(:create, 'offices') do
      @office = Office.new
    end
  end

  # POST /offices
  def create
    @office = Office.new(office_params)

    if @office.save
      redirect_to offices_path, notice: 'Office was successfully created.'
    else
      render :new
    end
  end

  # GET /offices/1/edit
  def edit
    can?(:update, 'offices') do
      load_office
    end
  end

  # PATCH/PUT /offices/1
  def update
    can?(:update, 'offices') do
      load_office
      if @office.update(office_params)
        redirect_to offices_path, notice: 'Office was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /offices/1
  def destroy
    can?(:delete, 'offices') do
      load_office
      @office.destroy
      redirect_to offices_path, notice: 'Office was successfully destroyed.'
    end
  end

  private
    def load_office
      @office = Office.find(params[:id])
    end

    def office_params
      params.require(:office).permit(:code, :name, :department_id, :division_id, :sector_city_id, :city_id)
    end
end
