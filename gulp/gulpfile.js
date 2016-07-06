'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var sassGlob = require('gulp-sass-glob');
var autoprefixer = require('gulp-autoprefixer');
var notify = require("gulp-notify");
var del = require('del');

// clean it up
gulp.task('clean', function() {
  return del([
    '/css'
  ], {
    force: true
  });
});

// gulp sass task
gulp.task('sass', function() {
  gulp.src(['../sass/your-theme.styles.scss'])
    .pipe(sourcemaps.init())
    .pipe(sassGlob())
    .pipe(sass().on('error', notify.onError('<%= error.message %>')))
    .pipe(autoprefixer())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('/css'));
});

// watch sass files
gulp.task('watch', function() {
  gulp.watch('/sass/**/*.scss', ['sass']);
});

gulp.task('default', ['clean', 'sass', 'watch']);
