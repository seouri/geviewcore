class PageController < ApplicationController
  def home
  end

  def about
  end

  def graph
    @level = params[:level].blank? ? 6 : params[:level].to_i
    @level = 6 if @level > 6
    @level = 2 if @level < 2
    @chromosome = 'chr' + (params[:chromosome] || '1').upcase
    @center = params[:center]
    @center = nil if @level == 6
  end

  def select_data
    @regions = params[:regions]
    @tracks = Track.order("data_type, name").where("id > 990")
    @data_type_css = {'CNV' => 'cnv', 'Gene Expression' => 'ge', 'Expert Knowledge' => 'genes', 'SNP' => 'snp', 'literature' => 'literature', 'total' => 'total'}
  end

  def summary
    @regions = params[:regions].split(/\s+/).uniq
    @genes = Gene.where(:symbol => @regions)
    @tracks = Track.where(:id => params[:track_ids])
    @resolution = params[:resolution].to_i
    @data_type_css = {'CNV' => 'cnv', 'Gene Expression' => 'ge', 'Expert Knowledge' => 'genes', 'SNP' => 'snp', 'literature' => 'literature', 'Summary' => 'total'}
    @summary = []
    bin_size = 10 ** @resolution
    @regions.each do |region|
      gene = Gene.where(:symbol => region).first
      data_type = {'CNV' => 0, 'Gene Expression' => 0, 'Expert Knowledge' => 0, 'SNP' => 0, 'literature' => 0, 'Summary' => 0}
      if gene.present?
        bin = (gene.start_position / bin_size) * bin_size 
        @tracks.each do |track|
          frequency = Histogram.where(:track_id => track.id).where(:level => @resolution).where(:chromosome => gene.chromosome).where(:bin => bin).select("frequency").first.frequency
          data_type[track.data_type] += frequency
        end
        ['CNV','Gene Expression', 'Expert Knowledge', 'SNP', 'literature'].each do |type|
          data_type['Summary'] += 1 if data_type[type] > 0
          #data_type[type] = "" if data_type[type] == 0
        end
        @summary.push([region, data_type['CNV'], data_type['Gene Expression'], data_type['Expert Knowledge'], data_type['SNP'], data_type['literature'], data_type['Summary'], gene.chromosome.gsub(/chr/, ""), @resolution, bin])
        @summary.sort!{|a, b| [b[6], b[4], b[1], b[2], b[3], a[5]] <=> [a[6], a[4], a[1], a[2], a[3], a[5]]}
      end
    end
  end
end
