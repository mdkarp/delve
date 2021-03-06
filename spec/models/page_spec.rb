require 'spec_helper'

describe Page do

  let(:document) { FactoryGirl.create(:document) }
  before { @page = document.pages.create(path: "2013-09-12_00-00-00.jpg") }

  subject { @page }

  it { should respond_to(:path) }
  it { should respond_to(:document_id) }
  it { should respond_to(:document) }
  its(:document) { should eq document }
  it { should be_valid }

  describe "when path is not present" do
    before { @page.path = " " }
    it { should_not be_valid }
  end

  describe "when path is already taken" do
    it "should be invalid" do
      page_with_same_path = @page.dup
      page_with_same_path.should_not be_valid
    end
  end

  # TODO: Refactor this with settings
  describe "when destroyed" do
    before { @page.path = 'test' }

    it 'should delete the associated file' do
      File.write(File.join(STORAGE_DIR,'test'),'foo')
      File.exist?(File.join(STORAGE_DIR,'test')).should be_true

      @page.destroy.should be_true
      File.exist?(File.join(STORAGE_DIR,'test')).should be_false
    end

    it 'should return false if the file cannot be deleted' do
      File.should_receive(:join).and_return(Exception)
      @page.destroy.should be_false
    end

  end

  describe "when rotated" do
    let(:test_image) { Magick::Image.new(100,200) }
    let(:location)   { File.join(STORAGE_DIR,'test.jpg') }
    let(:rotatepage) { FactoryGirl.create :page, :unassociated, :path => 'test.jpg' }

    before do
      test_image.write location
    end

    after do
      File.unlink location 
    end

    it "should be rotated" do
      img = Magick::Image.read(location).first
      img.columns.should eq(100)
      img.rows.should eq(200)

      rotatepage.rotate! "clockwise"
      img = Magick::Image.read(location).first
      img.columns.should eq(200)
      img.rows.should eq(100)
    end

  end

end
