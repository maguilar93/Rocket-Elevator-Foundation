class LeadsController < ApplicationController



  def index
  end

  def new
    @lead = Lead.new #generate data blank to create new form
  end

  def create
    @lead = Lead.new(lead_params)

    puts "CREATING"
    p = params["lead"].permit!
    puts "PARAMS = #{p}"
    file_attachment = p["attached_file"]
    # file_attachment = params["attached_file"]
    if file_attachment != nil
      # p["attached_file"] = file_attachment.read
      p["original_file_name"] = file_attachment.original_filename
      puts "WRITING UPLOAD"
      File.open(Rails.root.join('public', file_attachment.original_filename), 'wb') do |file|
        file.write(file_attachment.read)
      end
    end

    #Create ticket on Zendesk from Contact Form
    ZendeskAPI::Ticket.create!(@client, 
      :subject => "#{@lead.full_name} from #{@lead.company_name}",
      :requester => {"name": @lead.email},
      :comment => { :value => 
       "The contact #{@lead.full_name} from company #{@lead.company_name} can be reached at email #{@lead.email} and at phone number #{@lead.phone}. #{@lead.department} has a project named #{@lead.project_name} which would require contribution from Rocket Elevators. 
        #{@lead.project_desc}
        Attached Message: #{@lead.attached_file}
        The Contact uploaded an attachment"},
      :type => "question",  
      :priority => "urgent")
    

    #render json: @lead #test when submit button form
    if @lead.save

      ContactsMailer.contact_email(@lead).deliver
      flash[:notice] = "We received your request! "
      redirect_to :index
    else
      flash[:notice] = "Request not succesfull."
      redirect_to action:"new"
    end
  end

  def edit
  end
  #for get params when click submit form
  



  private
  def lead_params
    #params.require(name model)
    params.require(:lead).permit(:full_name,:company_name,:email,:phone,:project_name,:project_desc,:department,:message,:attached_file)
  end
end
