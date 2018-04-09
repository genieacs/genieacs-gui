class SectorCitiesController < ApplicationController
  # GET /sector_cities/new
  def new
    can?(:create, 'offices') do
      @sector_city = SectorCity.new
    end
  end

  # POST /sector_cities
  def create
    can?(:create, 'offices') do
      @sector_city = SectorCity.new(sector_city_params)

      if @sector_city.save
        redirect_to offices_path, notice: 'Sector city was successfully created.'
      else
        render :new
      end
    end
  end

  # GET /sector_cities/1/edit
  def edit
    can?(:update, 'offices') do
      load_sector_city
    end
  end

  # PATCH/PUT /sector_cities/1
  def update
    can?(:update, 'offices') do
      load_sector_city
      if @sector_city.update(sector_city_params)
        redirect_to offices_path, notice: 'Sector city was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /sector_cities/1
  def destroy
    can?(:delete, 'offices') do
      load_sector_city
      @sector_city.destroy
      redirect_to offices_path, notice: 'Sector city was successfully destroyed.'
    end
  end

  def cities
    load_sector_city
    render json: @sector_city.cities.order(code: :asc)
  end

  private
    def load_sector_city
      @sector_city = SectorCity.find(params[:id])
    end

    def sector_city_params
      params.require(:sector_city).permit(:code, :name, :department_id, :division_id)
    end
end
