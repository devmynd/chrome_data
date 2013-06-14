require_relative '../minitest_helper'

describe ChromeData::Vehicle do
  it 'returns a proper request name' do
    ChromeData::Vehicle.request_name.must_equal 'describeVehicle'
  end

  describe '.find_by_vin' do
    before do
      ChromeData.configure do |c|
        c.account_number = '123456'
        c.account_secret = '1111111111111111'
      end

      VCR.use_cassette('wsdl') do
        VCR.use_cassette('vehicles/WDDGF4HB1CR000000') do
          @vehicle = ChromeData::Vehicle.find_by_vin('WDDGF4HB1CR000000')
        end
      end
    end

    it 'returns a Vehicle object' do
      @vehicle.must_be_instance_of ChromeData::Vehicle
    end

    it 'sets model year on Vehicle' do
      @vehicle.model_year.must_equal 2012
    end

    it 'sets division on Vehicle' do
      @vehicle.division.must_equal 'Mercedes-Benz'
    end

    it 'sets model on Vehicle' do
      @vehicle.model.must_equal 'C-Class'
    end

    describe 'standard' do
      before do
        @standard = @vehicle.standard[0]
      end

      it "sets id" do
        @standard.fetch("id").must_equal 1236
      end

      it "sets description" do
        @standard.fetch("description").
          must_equal "1.8L 16-valve I4 turbocharged engine"
      end

      it "sets category" do
        @standard.fetch("category").must_equal "MECHANICAL"
      end

      it "sets style_ids" do
        @standard.fetch("style_ids").must_equal [337364, 337365]
      end
    end

    describe 'styles' do
      it 'sets id' do
        @vehicle.styles[0].id.must_equal 337364
        @vehicle.styles[1].id.must_equal 337365
      end

      it 'sets name' do
        @vehicle.styles[0].name.must_equal '4dr Sdn C250 Sport RWD'
        @vehicle.styles[1].name.must_equal '4dr Sdn C250 Luxury RWD'
      end

      it 'sets trim' do
        @vehicle.styles[0].trim.must_equal 'C250 Sport'
        @vehicle.styles[1].trim.must_equal 'C250 Luxury'
      end

      it 'sets name_without_trim' do
        @vehicle.styles[0].name_without_trim.must_equal '4dr Sdn RWD'
        @vehicle.styles[1].name_without_trim.must_equal '4dr Sdn RWD'
      end

      describe 'body_types' do
        it 'sets name' do
          @vehicle.styles[0].body_types[0].name.must_equal '4dr Car'
          @vehicle.styles[1].body_types[0].name.must_equal '4dr Car'
        end

        it 'sets id' do
          @vehicle.styles[0].body_types[0].id.must_equal 2
          @vehicle.styles[1].body_types[0].id.must_equal 2
        end
      end
    end

    describe 'engines' do
      it 'sets type' do
        @vehicle.engines[0].type.must_equal '4 Cylinder Engine'
      end
    end
  end
end
