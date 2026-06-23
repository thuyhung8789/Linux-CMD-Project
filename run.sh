#1. Sắp xếp các bộ phim theo ngày phát hành giảm dần rồi lưu ra một file mới
csvsort -c release_date -r tmdb-movies.csv > tmdb-movies-sorted.csv
#2.Lọc ra các bộ phim có đánh giá trung bình trên 7.5 rồi lưu ra một file mới
csvgrep -c vote_average -r '^(7\.[6-9]|[8-9]|10)' tmdb-movies.csv > Vote_avarage_7.5.csv

