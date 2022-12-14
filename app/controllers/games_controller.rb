require 'pry'
class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy try check]

  # GET /games or /games.json
  def index
    @games = Game.all
  end

  # GET /games/1 or /games/1.json
  def show 
    @keys = [
      'Q',
      'W',
      'E',
      'R',
      'T',
      'Y',
      'U',
      'I',
      'O',
      'P',
      'A',
      'S',
      'D',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
      'Z',
      'X',
      'C',
      'V',
      'B',
      'N',
      'M'
  ]
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit; end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    random_number = Random.rand(1..5757)

    @word = Word.find(random_number)
    @game.words << @word

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to game_url(@game), notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def try
    result = []
    @game.words.first.content.split('').each_with_index do |item, index|
      result.push(index) if item == params[:character].downcase
      @game.win if @game.check_win?
    end
    
    respond_to do |format|
      if @game.check_win?
        format.html { redirect_to game_url(@game), notice: "You\'ve won! #{@game.words.first.content}" }
        format.json { render :show, status: :ok, location: @game }
      elsif @game.attempts < 8 && !@game.won
        if !result.empty?
          @game.attempts += 1
          
          result.each do |item|
            @game.known_indexes << item
            if @game.check_win?
              @game.win
              format.html { redirect_to game_url(@game), notice: "You\'ve won! #{@game.words.first.content}" }
              format.json { render :show, status: :ok, location: @game }
              break
            end
          end
          @game.save!
          format.html { redirect_to game_url(@game), notice: "You got it! Lines #{result}" }
          format.json { render :show, status: :ok, location: @game }
        else
          @game.attempts += 1
          @game.save
          format.html { redirect_to game_url(@game), notice: 'Nope wrong choice!' }
          format.json { render json: @game, status: :ok }
        end
      elsif @game.attempts == 8 && !@game.won
        @game.attempts += 1
        @game.save!
        format.html { redirect_to game_url(@game), notice: 'You have lost!', status: :unprocessable_entity }
        format.json { render json: @game, status: :unprocessable_entity }
      end
    end
  end

  def check
    @game.attempts += 1
    @game.save
    respond_to do |format|
      if params[:check].downcase == @game.words.first.content
        @game.win
        format.html { redirect_to game_url(@game), notice: "You\'ve won! #{@game.words.first.content}" }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { redirect_to game_url(@game), notice: 'Nope wrong choice!' }
        format.json { render json: @game, status: :ok }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:attempts, :won)
  end
end
