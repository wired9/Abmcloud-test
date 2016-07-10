class UploadsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :no_file_uploaded

  def create
    io = params.require(:csv)
    filename = Rails.root.join('public', 'uploads', io.original_filename).to_s

    File.open(filename, 'wb') do |file|
    	file.write(io.read)
  	end

    case io.original_filename
    when /sku/
      ImportSkusJob.perform_later(filename)
    when /suppliers/
      ImportSuppliersJob.perform_later(filename)
    else
      flash[:error] = "File not recognized: #{io.original_filename}"
    end

		redirect_to new_upload_path
  end

  private

  def no_file_uploaded
    flash[:error] = 'No file uploaded'
    redirect_to new_upload_path
  end
end
