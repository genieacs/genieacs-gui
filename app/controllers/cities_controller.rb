class CitiesController < ApplicationController
  # GET /cities/new
  def new
    can?(:create, 'offices') do
      @city = City.new
    end
  end

  # POST /cities
  def create
    can?(:create, 'offices') do
      @city = City.new(city_params)

      if @city.save
        redirect_to offices_path, notice: 'City was successfully created.'
      else
        render :new
      end
    end
  end


  # GET /cities/1/edit
  def edit
    can?(:update, 'offices') do
      load_city
    end
  end

  # PATCH/PUT /cities/1
  def update
    can?(:update, 'offices') do
      load_city
      if @city.update(city_params)
        redirect_to offices_path, notice: 'City was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /cities/1
  def destroy
    can?(:destroy, 'offices') do
      load_city
      @city.destroy
      redirect_to offices_path, notice: 'City was successfully destroyed.'
    end
  end

  private
    def load_city
      @city = City.find(params[:id])
    end

    def city_params
      params.require(:city).permit(:code, :name, :department_id, :division_id, :sector_city_id)
    end
end
