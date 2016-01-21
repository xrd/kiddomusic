def process_directory( path )
  Dir.foreach path do |f|
    unless f =~ /^\.\.?$/
      process_song( File.join( path, f ) )
    end
  end
end

def process_song( path ) 
  # Symlink it into the music directory with a good name.
  basename = File.basename( path )
  # fix it
  fixed = basename.gsub( /\s/, '_' ).gsub( /[^a-zA-Z0-9\.]/, '_' )
  puts "Importing #{fixed}"
  File.symlink( path, File.join( "public", "songs", fixed ) )
  # Import it into the database
  # Do this later.
  
end

namespace :import do
  desc "Import songs"
  task :songs => :environment do
    path = ENV['path'].dup
    puts "Before: #{path}"
    # puts path.split( " " ).join "\n"
    path.gsub!( /\\/, "" )
    puts "After: #{path}"
    if Dir.exists? path
      process_directory( path )
    elsif File.exists? path
      process_song( path )
    else
      puts "That file or directory does not exist (or you did not specify one with path=path/to/file)"
    end
  end
	  
end
