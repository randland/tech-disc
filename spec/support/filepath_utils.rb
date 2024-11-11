module FilepathUtils
  def spec_relative_path(filepath)
    File.join(
      File.dirname(filepath).gsub("/spec", ""),
      File.basename(filepath).gsub("_spec.rb", "")
    )
  end
end
