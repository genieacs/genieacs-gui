class DepartmentsController < ApplicationController
  # GET /departments/new
  def new
    can?(:create, 'offices') do
      @department = Department.new
    end
  end

  # POST /departments
  def create
    can?(:create, 'offices') do
      @department = Department.new(department_params)
      if @department.save
        redirect_to offices_path, notice: 'Department was successfully created.'
      else
        render :new
      end
    end
  end

  # GET /departments/1/edit
  def edit
    can?(:update, 'offices') do
      load_department
    end
  end

  # PATCH/PUT /departments/1
  def update
    can?(:update, 'offices') do
      load_department
      if @department.update(department_params)
        redirect_to offices_path, notice: 'Department was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /departments/1
  def destroy
    can?(:delete, 'offices') do
      load_department
      @department.destroy
      redirect_to offices_path, notice: 'Department was successfully destroyed.'
    end
  end

  private
    def load_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:code, :name)
    end
end
