# docker_push_all
   Build a new docker image then push it to different Docker repositories include:  Dcoker Hub GitHub  AWS




#      - name: Set up Docker Buildx
#        uses: docker/setup-buildx-action@v3

#      - name: Login to Docker Hub
#        uses: docker/login-action@v3
#        with:
#          username: ${{ vars.DOCKERHUB_USERNAMEqqq }}
#          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          file: DockerfileQ
          push: true
          tags: |
            ${{ env.D_IMAGE_USER_NAME_TAG }}
            ${{ env.D_IMAGE_USER_NAME_LATEST }}

