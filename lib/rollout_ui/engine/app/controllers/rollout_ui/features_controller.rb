module RolloutUi
  class FeaturesController < RolloutUi::ApplicationController
    before_filter :wrapper, :only => [:index, :create, :destroy]

    def index
      @features = @wrapper.features.sort.map{ |feature| RolloutUi::Feature.new(feature) }
    end

    def create
      @wrapper.add_feature(params[:name])

      redirect_to features_path
    end

    def update
      @feature = RolloutUi::Feature.new(params[:id])

      @feature.percentage = params["percentage"] if params["percentage"]
      @feature.groups     = params["groups"]     if params["groups"]
      @feature.user_names = params["user_names"] if params["user_names"]

      redirect_to features_path
    end

    def destroy
      @wrapper.remove_feature(params[:id])

      redirect_to features_path
    end

  private

    def wrapper
      @wrapper = RolloutUi::Wrapper.new
    end
  end
end
