require 'spec_helper'
require 'pry'

describe 'Wine' do
  before do
    @wine = Wine.create(:name => "Borsao Garnacha",
                        :winery => "Borsao",
                        :vintage => "2016",
                        :origin => "Spain",
                        :price => "$9",
                        :rating => "6",
                        :tasting_notes => "Both on the nose and palate, this Garnacha is mildly angular and pinching, with a sense of rawness brought on by hard tannins. Its foxy plum flavors are jumpy and nervy, finishing peppery and jagged.",
                        :other_notes => "Would pair well with dark chocolate")
  end

  it 'has a name' do
    expect(@wine.name).to eq("Borsao Garnacha")
  end

  it 'has a winery' do
    expect(@wine.winery).to eq("Borsao")
  end

  it 'has a vintage' do
    expect(@wine.vintage).to eq("2016")
  end

  it 'has an origin' do
    expect(@wine.origin).to eq("Spain")
  end

  it 'has a price' do
    expect(@wine.price).to eq("$9")
  end

  it 'has a rating' do
    expect(@wine.rating).to eq("6")
  end

  it 'has tasting notes' do
    expect(@wine.tasting_notes).to include("mildly angular and pinching")
  end

  it 'has other notes' do
    expect(@wine.other_notes).not_to be_empty
  end
end
