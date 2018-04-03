class DivisionsController < ApplicationController
  # GET /divisions/new
  def new
    can?(:create, 'offices') do
      @division = Division.new
    end
  end

  # POST /divisions
  def create
    can?(:create, 'offices') do
      @division = Division.new(division_params)
      if @division.save
        redirect_to offices_path, notice: 'Division was successfully created.'
      else
        render :new
      end
    end
  end

  # GET /divisions/1/edit
  def edit
    can?(:update, 'offices') do
      load_division
    end
  end

  # PATCH/PUT /divisions/1
  def update
    can?(:update, 'offices') do
      load_division
      if @division.update(division_params)
        redirect_to offices_path, notice: 'Division was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /divisions/1
  def destroy
    can?(:delete, 'offices') do
      load_division
      @division.destroy
      redirect_to offices_path, notice: 'Division was successfully destroyed.'
    end
  end

  private
    def load_division
      @division = Division.find(params[:id])
    end

    def division_params
      params.require(:division).permit(:code, :name, :department_id)
    end
end
